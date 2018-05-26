Class {
	#name : #TriggersAPI,
	#superclass : #Object,
	#instVars : [
		'triggersMapping',
		'context'
	],
	#category : 'Cosmos-Triggers-API-Core-Model'
}

{ #category : #'instance creation' }
TriggersAPI class >> workingWith: aCompositeSystem [ 
	
	^ self new initializeWorkingWith: aCompositeSystem 
]

{ #category : #API }
TriggersAPI >> deregisterNamed: aName [

	| name |

	name := aName replaceAll: $_ with: Character space.

	self triggerManagementSystem deregisterNamed: name.

	^ ZnResponse noContent
]

{ #category : #'initialize-release' }
TriggersAPI >> initializeMappings [

	triggersMapping := [ :object | 
	String
		streamContents: [ :stream | 
			(NeoJSONWriter on: stream)
				for: ActionTrigger
					do: [ :mapping | 
					mapping
						mapAccessor: #name;
						mapAccessor: #creationDateTime to: 'created_on';
						mapAccessor: #triggeringPolicy to: 'policy';
						mapAccessor: #action;
						mapAccessor: #condition ];
				for: Action customDo: [ :mapping | mapping encoder: [ :action | action name ] ];
				for: PeriodicalTriggeringPolicy 
					customDo: [ :mapping | 
					mapping
						encoder: [ :policy | 
							{(#type -> #periodical).
							(#time_interval -> (policy instVarNamed: #timePeriod))} asOrderedDictionary  ] ];
				for: AlwaysTriggeringCondition
					customDo: [ :mapping | mapping encoder: [ :condition | 'true' ] ];
				for: Measure customDo: [: mapping | mapping encoder: [:measure | measure printString  ] ]; 
				for: DateTime
					customDo: [ :mapping | 
					mapping
						encoder: [ :dateTime | ISO8601DateTimeFormatter usingExtendedFormat format: dateTime ] ];
				prettyPrint: true;
				nextPut: object ] ]
]

{ #category : #'initialize-release' }
TriggersAPI >> initializeWorkingWith: aCompositeSystem [ 
	
	context := aCompositeSystem.
	
	self initializeMappings.

]

{ #category : #API }
TriggersAPI >> registerFrom: aJSON [

	^ [ [ | rawTrigger |

	rawTrigger := (NeoJSONReader on: aJSON readStream)
		propertyNamesAsSymbols: true;
		next.

	self triggerManagementSystem
		registerNamed: (rawTrigger at: #name)
		triggering: (context  parseActionFrom: rawTrigger) 
		accordingTo: (context parseTriggeringPolicyFrom: rawTrigger) 
		whenMeets: (context parseConditionFrom: rawTrigger).

	ZnResponse created: (ZnUrl fromString: 'localhost') ]
		on: ObjectAlreadyInSystem
		do: [ :signal | HTTPClientError signalConflict: signal messageText ] ]
		on: KeyNotFound , ParsingFailed 
		do: [ :signal | 
			HTTPClientError
				signalBadRequest:
					('{"error":{"code":400,"message":"Expected key <1s> was not found"}'
						expandMacrosWith: signal key) ]
]

{ #category : #systems }
TriggersAPI >> triggerManagementSystem [
	
	^ context triggerManagementSystem
]

{ #category : #API }
TriggersAPI >> triggers [

	^ ZnResponse
		ok: (ZnEntity json: (triggersMapping value: self triggerManagementSystem triggers))
]
