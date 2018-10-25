Class {
	#name : #TriggersRESTfulWebService,
	#superclass : #RESTfulWebService,
	#instVars : [
		'cosmos'
	],
	#category : #'Cosmos-API-Triggers'
}

{ #category : #'instance creation' }
TriggersRESTfulWebService class >> workingWith: aCosmosSystem [
	
	^ self new initializeWorkingWith: aCosmosSystem
]

{ #category : #API }
TriggersRESTfulWebService >> createTriggerBasedOn: anHttpRequest within: aContext [

	^ [ self
		withCreatedResourceDo: [ :trigger | 
			self triggerManagementSystem register: trigger.
			trigger ]
		decodedUsing: #triggers
		basedOn: anHttpRequest
		within: (TriggerDecodingContext workingWith: cosmos) ]
		on: InstanceCreationFailed
		do: [ :signal | HTTPClientError signalBadRequest: signal messageText ]
]

{ #category : #API }
TriggersRESTfulWebService >> deregisterNamed: aName [

	| name |

	name := aName replaceAll: $_ with: Character space.

	self triggerManagementSystem deregisterNamed: name.

	^ ZnResponse noContent
]

{ #category : #API }
TriggersRESTfulWebService >> getTriggersBasedOn: anHttpRequest within: aContext [

	^ self
		get: [ self triggerManagementSystem triggers ]
		asCollectionEncodedUsing: #triggers
		basedOn: anHttpRequest
		within: aContext
]

{ #category : #'private - systems' }
TriggersRESTfulWebService >> identifierSystem [

	^ cosmos systemImplementing: #IdentifierSystemInterface
]

{ #category : #initialization }
TriggersRESTfulWebService >> initializeWorkingWith: aCosmosSystem [

	cosmos := aCosmosSystem
]

{ #category : #'private - accessing' }
TriggersRESTfulWebService >> locationOf: anActionTrigger [

	| baseUrl |

	baseUrl := baseUrlOptional
		withContentDo: [ :theBaseUrl | theBaseUrl ]
		ifUnused: [ '' asZnUrl ].

	^ '<1p>/<2p>'
		expandMacrosWith: baseUrl / 'triggers' asZnUrl
		with: (self identifierSystem identifierOf: anActionTrigger)
]

{ #category : #specification }
TriggersRESTfulWebService >> specification [
	
	^ TriggersRESTfulWebServiceSpecification new
]

{ #category : #systems }
TriggersRESTfulWebService >> triggerManagementSystem [
	
	^ cosmos systemImplementing: #TriggerManagementSystemInterface
]
