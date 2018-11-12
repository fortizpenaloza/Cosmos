Class {
	#name : #TriggersRESTfulController,
	#superclass : #ResourceRESTfulController,
	#instVars : [
		'cosmos'
	],
	#category : #'Cosmos-API-Triggers'
}

{ #category : #'instance creation' }
TriggersRESTfulController class >> workingWith: aCosmosSystem [
	
	^ self new initializeWorkingWith: aCosmosSystem
]

{ #category : #API }
TriggersRESTfulController >> createTriggerBasedOn: anHttpRequest within: aContext [

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
TriggersRESTfulController >> deregisterNamed: aName [

	| name |

	name := aName replaceAll: $_ with: Character space.

	self triggerManagementSystem deregisterNamed: name.

	^ ZnResponse noContent
]

{ #category : #API }
TriggersRESTfulController >> getTriggersBasedOn: anHttpRequest within: aContext [

	^ self
		get: [ self triggerManagementSystem triggers ]
		asCollectionEncodedUsing: #triggers
		basedOn: anHttpRequest
		within: aContext
]

{ #category : #'private - systems' }
TriggersRESTfulController >> identifierSystem [

	^ cosmos systemImplementing: #IdentifierSystemInterface
]

{ #category : #initialization }
TriggersRESTfulController >> initializeWorkingWith: aCosmosSystem [

	cosmos := aCosmosSystem
]

{ #category : #'private - accessing' }
TriggersRESTfulController >> locationOf: anActionTrigger [

	| baseUrl |

	baseUrl := baseUrlOptional
		withContentDo: [ :theBaseUrl | theBaseUrl ]
		ifUnused: [ '' asZnUrl ].

	^ '<1p>/<2p>'
		expandMacrosWith: baseUrl / 'triggers' asZnUrl
		with: (self identifierSystem identifierOf: anActionTrigger)
]

{ #category : #'private - accessing' }
TriggersRESTfulController >> provideHypermediaPolicy [

	^ NonHypermediaDrivenRESTfulControllerPolicy new
]

{ #category : #'private - accessing' }
TriggersRESTfulController >> providePaginationPolicy [

	^ RESTFullControllerDoNotPaginateCollectionsPolicy for: self
]

{ #category : #specification }
TriggersRESTfulController >> specification [
	
	^ TriggersRESTfulControllerSpecification new
]

{ #category : #systems }
TriggersRESTfulController >> triggerManagementSystem [
	
	^ cosmos systemImplementing: #TriggerManagementSystemInterface
]
