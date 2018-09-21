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

	^ cosmos systemImplementing: #ActionManagementSystemInterface
]

{ #category : #API }
ActionsWebService >> createActionBasedOn: anHttpRequest [

	^ [ [ | action |

	action := self
		decode: anHttpRequest contents
		encodedAs: anHttpRequest contentType
		to: #actions
		within: nil.

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

{ #category : #'as yet unclassified' }
ActionsWebService >> encode: anObject of: aKeyRepresentingObjectType to: aMediaType within: aContext [

	^ (mappingRuleSet ruleToEncode: aKeyRepresentingObjectType to: aMediaType)
		applyOn: anObject
		within: aContext
]

{ #category : #API }
ActionsWebService >> getActionsBasedOn: anHttpRequest within: aContext [

	^ [ [ | mimeType actions encodedActions |

	mimeType := ZnMimeType fromString: anHttpRequest accept.

	actions := self actionManagementSystem actions.

	encodedActions := self
		encode: actions
		of: #actions
		to: mimeType
		within: aContext .

	ZnResponse ok: (ZnEntity json: encodedActions) ]
		on: ConflictingObjectFound
		do: [ :signal | HTTPClientError signalConflict: signal messageText ] ]
		on: ObjectNotFound
		do: [ :signal | HTTPClientError signalBadRequest: signal messageText ]
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
