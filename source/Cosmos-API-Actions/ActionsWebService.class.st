Class {
	#name : #ActionsWebService,
	#superclass : #Object,
	#instVars : [
		'context',
		'cosmos',
		'mappingRuleSet'
	],
	#category : #'Cosmos-API-Actions'
}

{ #category : #'instance creation' }
ActionsWebService class >> workingWith: aCosmosSystem [
	
	^ self new initializeWorkingWith: aCosmosSystem
]

{ #category : #'instance creation' }
ActionsWebService class >> workingWithin: aContext [
	
	^ self new initializeWorkingWithin: aContext 
]

{ #category : #systems }
ActionsWebService >> actionManagementSystem [

	^ context actionManagementSystem
]

{ #category : #API }
ActionsWebService >> actionsFor: anHttpRequest [

	| mimeType |

	mimeType := ZnMimeType fromString: anHttpRequest accept.

	^ [ [ ZnResponse
		ok:
			(ZnEntity
				json:
					(context
						encode: self actionManagementSystem actions
						of: #actions
						to: mimeType
						within: aContext)) ]
		on: ConflictingObjectFound
		do: [ :signal | HTTPClientError signalConflict: signal messageText ] ]
		on: ObjectNotFound
		do: [ :signal | HTTPClientError signalBadRequest: signal messageText ]
]

{ #category : #API }
ActionsWebService >> createActionBasedOn: aJSON [

	| action |
	^ [ [ | rawAction |
	
	action := self decode: aJSON contents encodedAs: aJSON contentType to: #actions within: nil.

	rawAction := (NeoJSONReader on: aJSON readStream)
		propertyNamesAsSymbols: true;
		next.

	action := Action named: (context parseNameFrom: rawAction)
		evaluating: (SendHttpRequestPolicy sending: (context parseRequestFrom: rawAction)).
	
	self actionManagementSystem register: action.

	ZnResponse created: (ZnUrl fromString: 'localhost') ]
		on: ConflictingObjectFound
		do: [ :signal | HTTPClientError signalConflict: signal messageText ] ]
		on: KeyNotFound , DecodingFailed
		do: [ :signal | 
			HTTPClientError
				signalBadRequest: ('Expected key <1s> was not found' expandMacrosWith: signal key) ]
]

{ #category : #'private - encoding and deconding' }
ActionsWebService >> decode: aJSON encodedAs: aMediaType to: aKeyRepresentingObjectType within: aContext [

	^ (mappingRuleSet ruleToDecode: aMediaType to: aKeyRepresentingObjectType)
		applyOn: aJSON
		within: aContext
]

{ #category : #API }
ActionsWebService >> deregisterNamed: aName [

	| name |

	name := aName replaceAll: $_ with: Character space.

	self actionManagementSystem
		actionNamed: name
		ifFound: [ :action | self actionManagementSystem deregister: action ]
		ifNone: [ ObjectNotFound signal ].

	^ ZnResponse noContent
]

{ #category : #initialization }
ActionsWebService >> initializeWorkingWith: aCosmosSystem [

	cosmos := aCosmosSystem.
	mappingRuleSet := (ReflectiveMappingRuleSetBuilder
		for: self specification) build
]

{ #category : #initialization }
ActionsWebService >> initializeWorkingWithin: aContext [

	context := aContext
]

{ #category : #accessing }
ActionsWebService >> specification [
	
	^ ActionsWebServiceSpecification new
]
