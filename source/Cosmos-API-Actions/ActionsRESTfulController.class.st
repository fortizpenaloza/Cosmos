Class {
	#name : #ActionsRESTfulController,
	#superclass : #ResourceRESTfulController,
	#instVars : [
		'cosmos'
	],
	#category : #'Cosmos-API-Actions'
}

{ #category : #'instance creation' }
ActionsRESTfulController class >> workingWith: aCosmosSystem [
	
	^ self new initializeWorkingWith: aCosmosSystem
]

{ #category : #'private - systems' }
ActionsRESTfulController >> actionManagementSystem [

	^ cosmos systemImplementing: #ActionManagementSystemInterface
]

{ #category : #'private - API' }
ActionsRESTfulController >> actionRequestedIn: anHttpRequest [

	^ self actionManagementSystem actionIdentifiedBy: (anHttpRequest at: #identifier)
]

{ #category : #API }
ActionsRESTfulController >> createActionBasedOn: anHttpRequest within: aContext [

	^ self
		withCreatedResourceDo: [ :action | self actionManagementSystem register: action ]
		decodedUsing: self specification actionMappingKey 
		basedOn: anHttpRequest
		within: aContext
]

{ #category : #API }
ActionsRESTfulController >> deleteActionBasedOn: anHttpRequest within: aContext [

	self
		withActionRequestedIn: anHttpRequest
		do: [ :action | self actionManagementSystem deregister: action ].

	^ ZnResponse noContent
]

{ #category : #'private - accessing' }
ActionsRESTfulController >> entityTagOf: anAction encodedAs: aMediaType [

	^ ZnETag
		with:
			(SHA1 new
				hashMessage:
					('<1s>-<2s>-<3s>'
						expandMacrosWith: (self identifierOf: anAction) asString
						with: (self lastModificationOf: anAction) asString
						with: aMediaType asString)) hex
]

{ #category : #API }
ActionsRESTfulController >> getActionBasedOn: anHttpRequest within: aContext [

	^ self
		get: [ self actionRequestedIn: anHttpRequest  ]
		encodedUsing: self specification actionMappingKey 
		basedOn: anHttpRequest
		within: aContext
]

{ #category : #API }
ActionsRESTfulController >> getActionsBasedOn: anHttpRequest within: aContext [

	^ self
		get: [ self actionManagementSystem actions ]
		asCollectionEncodedUsing: self specification actionsMappingKey 
		basedOn: anHttpRequest
		within: aContext
]

{ #category : #'private - accessing' }
ActionsRESTfulController >> identifierOf: anAction [

	^ self identifierSystem identifierOf: anAction
]

{ #category : #'private - systems' }
ActionsRESTfulController >> identifierSystem [

	^ cosmos systemImplementing: #IdentifierSystemInterface
]

{ #category : #initialization }
ActionsRESTfulController >> initializeWorkingWith: aCosmosSystem [

	cosmos := aCosmosSystem
]

{ #category : #'private - accessing' }
ActionsRESTfulController >> lastModificationOf: anAction [ 

	^ self metadataSystem 
		dataDescribing: #registration_timestamp
		of: anAction
]

{ #category : #'private - accessing' }
ActionsRESTfulController >> locationOf: anAction [

	| baseUrl |

	baseUrl := baseUrlOptional
		withContentDo: [ :theBaseUrl | theBaseUrl ]
		ifUnused: [ '' asZnUrl ].

	^ '<1p>/<2p>'
		expandMacrosWith: baseUrl / 'actions' asZnUrl
		with: (self identifierSystem identifierOf: anAction)
]

{ #category : #'private - systems' }
ActionsRESTfulController >> metadataSystem [

	^ cosmos systemImplementing: #MetadataSystemInterface
]

{ #category : #'private - accessing' }
ActionsRESTfulController >> provideHypermediaPolicy [

	^ HypermediaDrivenRESTfulControllerPolicy for: self
]

{ #category : #'private - accessing' }
ActionsRESTfulController >> providePaginationPolicy [

	^ RESTfulControllerDoNotPaginateCollectionsPolicy for: self
]

{ #category : #specification }
ActionsRESTfulController >> specification [
	
	^ ActionsRESTfulControllerSpecification new
]

{ #category : #'private - API' }
ActionsRESTfulController >> withActionRequestedIn: anHttpRequest do: aBlock [

	aBlock value: (self actionRequestedIn: anHttpRequest)
]
