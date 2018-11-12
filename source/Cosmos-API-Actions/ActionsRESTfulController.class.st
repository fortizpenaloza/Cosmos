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

{ #category : #API }
ActionsRESTfulController >> createActionBasedOn: anHttpRequest within: aContext [

	^ self
		withCreatedResourceDo: [ :action | self actionManagementSystem register: action ]
		decodedUsing: #actions
		basedOn: anHttpRequest
		within: aContext
]

{ #category : #API }
ActionsRESTfulController >> deleteActionBasedOn: anHttpRequest within: aContext [

	| name |

	name := (anHttpRequest at: #name) replaceAll: $_ with: Character space.

	self actionManagementSystem
		actionNamed: name
		ifFound: [ :action | self actionManagementSystem deregister: action ]
		ifNone: [ ObjectNotFound signal ].

	^ ZnResponse noContent
]

{ #category : #API }
ActionsRESTfulController >> getActionsBasedOn: anHttpRequest within: aContext [

	^ self
		get: [ self actionManagementSystem actions ]
		asCollectionEncodedUsing: #actions
		basedOn: anHttpRequest
		within: aContext
]

{ #category : #'private - systems' }
ActionsRESTfulController >> identifierSystem [

	^ cosmos systemImplementing: #IdentifierSystemInterface
]

{ #category : #initialization }
ActionsRESTfulController >> initializeWorkingWith: aCosmosSystem [

	cosmos := aCosmosSystem
]

{ #category : #'private - API' }
ActionsRESTfulController >> locationOf: anAction [

	| baseUrl |

	baseUrl := baseUrlOptional
		withContentDo: [ :theBaseUrl | theBaseUrl ]
		ifUnused: [ '' asZnUrl ].

	^ '<1p>/<2p>'
		expandMacrosWith: baseUrl / 'actions' asZnUrl
		with: (self identifierSystem identifierOf: anAction)
]

{ #category : #'private - accessing' }
ActionsRESTfulController >> provideHypermediaPolicy [

	^ NonHypermediaDrivenRESTfulControllerPolicy new
]

{ #category : #'private - accessing' }
ActionsRESTfulController >> providePaginationPolicy [

	^ RESTFullControllerDoNotPaginateCollectionsPolicy for: self
]

{ #category : #specification }
ActionsRESTfulController >> specification [
	
	^ ActionsRESTfulControllerSpecification new
]
