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

	aContext hold: cosmos under: #cosmos.

	^ [ self
		withCreatedResourceDo: [ :trigger | 
			self triggerManagementSystem register: trigger.
			trigger ]
		decodedUsing: self specification triggerMappingKey 
		basedOn: anHttpRequest
		within: aContext ]
		on: InstanceCreationFailed
		do: [ :signal | HTTPClientError signalBadRequest: signal messageText ]
]

{ #category : #API }
TriggersRESTfulController >> deleteTriggerBasedOn: anHttpRequest within: aContext [

	self
		withTriggerRequestedIn: anHttpRequest
		do: [ :trigger | self triggerManagementSystem deregister: trigger ].

	^ ZnResponse noContent
]

{ #category : #'private - accessing' }
TriggersRESTfulController >> entityTagOf: anActionTrigger encodedAs: aMediaType [ 
	
	^ ZnETag
		with:
			(SHA1 new
				hashMessage:
					('<1s>-<2s>-<3s>'
						expandMacrosWith: (self identifierOf: anActionTrigger) asString
						with: (self lastModificationOf: anActionTrigger) asString
						with: aMediaType asString)) hex
]

{ #category : #API }
TriggersRESTfulController >> getTriggerBasedOn: anHttpRequest within: aContext [

	^ self
		get: [ self triggerRequestedIn: anHttpRequest ]
		encodedUsing: self specification triggerMappingKey
		basedOn: anHttpRequest
		within: aContext
]

{ #category : #API }
TriggersRESTfulController >> getTriggersBasedOn: anHttpRequest within: aContext [

	^ self
		get: [ self triggerManagementSystem triggers ]
		asCollectionEncodedUsing: self specification triggersMappingKey 
		basedOn: anHttpRequest
		within: aContext
]

{ #category : #'private - accessing' }
TriggersRESTfulController >> identifierOf: anActionTrigger [

	^ self identifierSystem identifierOf: anActionTrigger
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
TriggersRESTfulController >> lastModificationOf: anActionTrigger [

	^ self timestampingSystem lastModificationOf: anActionTrigger
]

{ #category : #'private - accessing' }
TriggersRESTfulController >> locationOf: anActionTrigger [

	| baseUrl |

	baseUrl := baseUrlOptional
		withContentDo: [ :theBaseUrl | theBaseUrl ]
		ifUnused: [ '' asZnUrl ].

	^  baseUrl / self specification endpoint / (self identifierOf: anActionTrigger) asString 
]

{ #category : #'private - accessing' }
TriggersRESTfulController >> provideHypermediaPolicy [

	^ HypermediaDrivenRESTfulControllerPolicy for: self
]

{ #category : #'private - accessing' }
TriggersRESTfulController >> providePaginationPolicy [

	^ RESTfulControllerDoNotPaginateCollectionsPolicy for: self
]

{ #category : #specification }
TriggersRESTfulController >> specification [
	
	^ TriggersRESTfulControllerSpecification new
]

{ #category : #'private - systems' }
TriggersRESTfulController >> timestampingSystem [
	
	^ cosmos systemImplementing: #TimestampingSystemInterface
]

{ #category : #'private - systems' }
TriggersRESTfulController >> triggerManagementSystem [
	
	^ cosmos systemImplementing: #TriggerManagementSystemInterface
]

{ #category : #'private - API' }
TriggersRESTfulController >> triggerRequestedIn: anHttpRequest [

	^ self triggerManagementSystem triggerIdentifiedBy: (anHttpRequest at: #identifier)
]

{ #category : #'private - API' }
TriggersRESTfulController >> withTriggerRequestedIn: anHttpRequest do: aBlock [

	aBlock value: (self triggerRequestedIn: anHttpRequest)
]
