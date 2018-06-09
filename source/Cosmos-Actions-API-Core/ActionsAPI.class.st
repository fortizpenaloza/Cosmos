Class {
	#name : #ActionsAPI,
	#superclass : #Object,
	#instVars : [
		'context',
		'actionsMapping'
	],
	#category : 'Cosmos-Actions-API-Core-Model'
}

{ #category : #'instance creation' }
ActionsAPI class >> workingWith: aContext [

	^ self new initializeWorkingWith: aContext 
]

{ #category : #systems }
ActionsAPI >> actionManagementSystem [

	^ context actionManagementSystem
]

{ #category : #API }
ActionsAPI >> actions [

	^ ZnResponse
		ok: (ZnEntity json: (actionsMapping value: self actionManagementSystem actions))
]

{ #category : #API }
ActionsAPI >> deregisterNamed: aName [

	|name | 
	
	name := aName replaceAll: $_ with: Character space.
	
	self actionManagementSystem deregisterNamed: name.

	^ ZnResponse noContent
]

{ #category : #'initialize-release' }
ActionsAPI >> initializeMappings [

	actionsMapping := [ :action | 
	String
		streamContents: [ :stream | 
			(NeoJSONWriter on: stream)
				for: Action
					do: [ :mapping | 
					mapping
						mapAccessor: #name;
						mapAccessor: #creationDateTime to: #created_on;
						mapInstVar: #evaluationPolicy to: #http_request ];
				for: ZnRequest
					do: [ :mapping | 
					mapping
						mapAccessor: #requestLine to: #request_line;
						mapAccessor: #headers;
						mapAccessor: #entity ];
				for: ZnRequestLine
					do: [ :mapping | 
					mapping
						mapAccessor: #method;
						mapAccessor: #uri to: #URL;
						mapInstVar: #version ];
				for: ZnUrl customDo: [ :mapping | mapping encoder: [ :url | url printString ] ];
				for: ZnHeaders do: [ :mapping | mapping mapAccessor: #headers ];
				for: Association
					do: [ :mapping | 
					mapping
						mapAccessor: #key;
						mapAccessor: #value ];
				for: DateTime
					customDo: [ :mapping | 
					mapping
						encoder: [ :dateTime | ISO8601DateTimeFormatter usingExtendedFormat format: dateTime ] ];
				prettyPrint: true;
				nextPut: action] ]
]

{ #category : #'initialize-release' }
ActionsAPI >> initializeWorkingWith: aContext [

	context := aContext.
	self initializeMappings
]

{ #category : #API }
ActionsAPI >> registerFrom: aJSON [

	^ [ [ | rawAction |

	rawAction := (NeoJSONReader on: aJSON readStream)
		propertyNamesAsSymbols: true;
		next.

	self actionManagementSystem
		registerNamed: (context parseNameFrom: rawAction)
		toEvaluate: (context parseRequestFrom: rawAction).

	ZnResponse created: (ZnUrl fromString: 'localhost') ]
		on: ConflictingObjectFound
		do: [ :signal | 
			HTTPClientError
				signalConflict: ('{"error":{"code": 409,"message":"<1s>"}}' expandMacrosWith: signal messageText) ] ]
		on: KeyNotFound , ParsingFailed
		do: [ :signal | 
			HTTPClientError
				signalBadRequest:
					('{"error":{"code":400,"message":"Expected key <1s> was not found"}'
						expandMacrosWith: signal key) ]
]
