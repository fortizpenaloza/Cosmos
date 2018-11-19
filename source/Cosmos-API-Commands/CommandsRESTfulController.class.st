Class {
	#name : #CommandsRESTfulController,
	#superclass : #ResourceRESTfulController,
	#instVars : [
		'cosmos'
	],
	#category : #'Cosmos-API-Commands'
}

{ #category : #'instance creation' }
CommandsRESTfulController class >> workingWith: aCosmosSystem [
	
	^ self new initializeWorkingWith: aCosmosSystem
]

{ #category : #'private - systems' }
CommandsRESTfulController >> commandManagementSystem [

	^ cosmos systemImplementing: #CommandManagementSystemInterface
]

{ #category : #API }
CommandsRESTfulController >> createCommandBasedOn: anHttpRequest within: aContext [

	^ self
		withCreatedResourceDo: [ :commandWithPriority | self commandManagementSystem register: commandWithPriority ]
		decodedUsing: self specification commandMappingKey 
		basedOn: anHttpRequest
		within: aContext
]

{ #category : #API }
CommandsRESTfulController >> deleteCommandBasedOn: anHttpRequest within: aContext [

	^ [ | identifier |

	identifier := anHttpRequest at: #identifier.

	self commandManagementSystem
		withCommandIdentifiedBy: identifier
		do: [ :commandWithPriority | 
			self commandManagementSystem deregister: commandWithPriority.
			ZnResponse noContent ] ]
		on: ObjectNotFound
		do: [ :signal | HTTPClientError signalNotFound: signal messageText ]
]

{ #category : #API }
CommandsRESTfulController >> dequeueCommandBasedOn: anHttpRequest within: aContext [

	^ self
		get: [ self commandManagementSystem dequeueCommand ]
		encodedUsing: self specification commandMappingKey 
		basedOn: anHttpRequest
		within: aContext
]

{ #category : #'private - accessing' }
CommandsRESTfulController >> entityTagOf: aCommandWithPriority encodedAs: aMediaType [

	^ ZnETag
		with:
			(SHA1 new
				hashMessage:
					('<1s>-<2s>-<3s>'
						expandMacrosWith: (self identifierOf: aCommandWithPriority) asString
						with: (self lastModificationOf: aCommandWithPriority) asString
						with: aMediaType asString)) hex
]

{ #category : #API }
CommandsRESTfulController >> getCommandsBasedOn: anHttpRequest within: aContext [

	^ self
		get: [ self commandManagementSystem commands ]
		asCollectionEncodedUsing: self specification commandsMappingKey 
		basedOn: anHttpRequest
		within: aContext
]

{ #category : #'private - accessing' }
CommandsRESTfulController >> identifierOf: aCommandWithPriority [

	^ self identifierSystem identifierOf: aCommandWithPriority
]

{ #category : #'private - systems' }
CommandsRESTfulController >> identifierSystem [

	^ cosmos systemImplementing: #IdentifierSystemInterface
]

{ #category : #initialization }
CommandsRESTfulController >> initializeWorkingWith: aCosmosSystem [

	cosmos := aCosmosSystem
]

{ #category : #'private - accessing' }
CommandsRESTfulController >> lastModificationOf: aCommandWithPriority [ 

	^ self metadataSystem 
		dataDescribing: #registration_timestamp
		of: aCommandWithPriority
]

{ #category : #'private - accessing' }
CommandsRESTfulController >> locationOf: aCommandWithPriority [

	| baseUrl |

	baseUrl := baseUrlOptional
		withContentDo: [ :theBaseUrl | theBaseUrl ]
		ifUnused: [ '' asZnUrl ].

	^ baseUrl / self specification endpoint / (self identifierOf: aCommandWithPriority) asString 
]

{ #category : #systems }
CommandsRESTfulController >> metadataSystem [

	^ cosmos systemImplementing: #MetadataSystemInterface
]

{ #category : #'private - accessing' }
CommandsRESTfulController >> provideHypermediaPolicy [

	^ HypermediaDrivenRESTfulControllerPolicy for: self
]

{ #category : #'private - accessing' }
CommandsRESTfulController >> providePaginationPolicy [

	^ RESTfulControllerDoNotPaginateCollectionsPolicy for: self
]

{ #category : #specification }
CommandsRESTfulController >> specification [

	^ CommandsRESTfulControllerSpecification new
]
