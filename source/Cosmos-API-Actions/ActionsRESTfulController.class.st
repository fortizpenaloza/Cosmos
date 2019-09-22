"
I'm a RESTful controller allowing to get, create and delete actions from a Cosmos system.
"
Class {
	#name : #ActionsRESTfulController,
	#superclass : #SingleResourceRESTfulController,
	#instVars : [
		'cosmos',
		'requestHandler'
	],
	#category : #'Cosmos-API-Actions'
}

{ #category : #'instance creation' }
ActionsRESTfulController class >> workingWith: aCosmosSystem [
	
	^ self new initializeWorkingWith: aCosmosSystem
]

{ #category : #'private - systems' }
ActionsRESTfulController >> actionManagementSystem [

	^ cosmos >> #ActionManagementSystemInterface
]

{ #category : #'private - media types' }
ActionsRESTfulController >> actionVersion1dot0dot0MediaType [

	^ self jsonMediaType: 'action' vendoredBy: 'cosmos' version: '1.0.0'
]

{ #category : #'private - encoding and decoding' }
ActionsRESTfulController >> configureActionDecodingOn: aReader [

	^ aReader
		for: Action
			customDo: [ :mapping | 
			mapping
				decoder: [ :rawAction | 
					Action
						named: ( rawAction at: #name )
						sending: ( HTTPRequestDecoder new decode: ( rawAction at: #http_request ) )
					]
			];
		nextAs: Action
]

{ #category : #'private - encoding and decoding' }
ActionsRESTfulController >> configureActionEncodingOn: aWriter within: aRequestContext [

	aWriter
		for: Action
			do: [ :mapping | 
			mapping mapInstVar: #name.
			( mapping mapInstVar: #evaluationPolicy to: #http_request ) valueSchema: #Policy.
			mapping mapAsHypermediaControls: [ :action | aRequestContext hypermediaControlsFor: action ]
			];
		for: #Policy
			customDo: [ :mapping | mapping encoder: [ :policy | policy instVarNamed: #requestToSend ] ];
		for: ZnRequest
			do: [ :mapping | 
			mapping
				mapAccessor: #requestLine to: #request_line;
				mapAccessor: #headers;
				mapAccessor: #entity
			];
		for: ZnRequestLine
			do: [ :mapping | 
			mapping
				mapAccessor: #method;
				mapAccessor: #uri to: #url;
				mapInstVar: #version
			];
		for: ZnUrl customDo: [ :mapping | mapping encoder: [ :url | url printString ] ];
		for: ZnHeaders
			customDo: [ :mapping | mapping encoder: [ :headers | headers headers associations ] ];
		for: ZnStringEntity
			do: [ :mapping | 
			mapping
				mapAccessor: #contentType;
				mapAccessor: #contents
			];
		for: ZnMimeType customDo: [ :mapping | mapping encoder: [ :mimeType | mimeType printString ] ];
		for: Association
			do: [ :mapping | 
			mapping
				mapAccessor: #key;
				mapAccessor: #value
			]
]

{ #category : #API }
ActionsRESTfulController >> createActionBasedOn: anHttpRequest within: aContext [

	^ self requestHandler
		withResourceCreatedFrom: anHttpRequest
		within: aContext
		do: [ :action | self actionManagementSystem register: action ]
]

{ #category : #routes }
ActionsRESTfulController >> declareCreateActionRoute [

	^ ( RouteSpecification
		handling: #POST
		at: self endpoint
		evaluating: [ :httpRequest :requestContext | self createActionBasedOn: httpRequest within: requestContext ] )
		asCorsAware
]

{ #category : #routes }
ActionsRESTfulController >> declareDeleteActionRoute [

	^ ( RouteSpecification
		handling: #DELETE
		at: self identifierTemplate
		evaluating: [ :httpRequest :requestContext | self deleteActionBasedOn: httpRequest within: requestContext ] )
		asCorsAware
]

{ #category : #routes }
ActionsRESTfulController >> declareGetActionRoute [

	^ ( RouteSpecification
		handling: #GET
		at: self endpoint
		evaluating: [ :httpRequest :requestContext | self getActionBasedOn: httpRequest within: requestContext ] )
		asCorsAware
]

{ #category : #routes }
ActionsRESTfulController >> declareGetActionsRoute [

	^ ( RouteSpecification
		handling: #GET
		at: self endpoint
		evaluating: [ :httpRequest :requestContext | self getActionsBasedOn: httpRequest within: requestContext ] )
		asCorsAware
]

{ #category : #API }
ActionsRESTfulController >> deleteActionBasedOn: anHttpRequest within: aRequestContext [

	^ self requestHandler 
		from: anHttpRequest
		within: aRequestContext
		get: [ :identifier | self actionManagementSystem actionIdentifiedBy: identifier ]
		thenDo: [ :action | self actionManagementSystem deregister: action ]
]

{ #category : #API }
ActionsRESTfulController >> getActionBasedOn: anHttpRequest within: aContext [

	^ self requestHandler
		from: anHttpRequest
		within: aContext
		get: [ :identifier | self actionManagementSystem actionIdentifiedBy: identifier ]
]

{ #category : #API }
ActionsRESTfulController >> getActionsBasedOn: anHttpRequest within: aContext [

	^ self requestHandler
		from: anHttpRequest
		within: aContext
		getCollection: [ self actionManagementSystem actions ]
]

{ #category : #'private - API' }
ActionsRESTfulController >> identifierOf: anAction [

	^ self identifierSystem identifierOf: anAction
]

{ #category : #'private - systems' }
ActionsRESTfulController >> identifierSystem [

	^ cosmos >> #IdentifierSystemInterface
]

{ #category : #initialization }
ActionsRESTfulController >> initializeRequestHandler [

	requestHandler := RESTfulRequestHandlerBuilder new
		handling: 'actions'
			locatingResourcesWith: [ :action :requestContext | self identifierOf: action ]
			extractingIdentifierWith: [ :httpRequest | self identifierIn: httpRequest ];
		beHypermediaDriven;
		whenAccepting: self actionVersion1dot0dot0MediaType
			decodeFromJsonApplying: [ :json :reader | self configureActionDecodingOn: reader ];
		whenResponding: self actionVersion1dot0dot0MediaType
			encodeToJsonApplying:
				[ :resource :requestContext :writer | self configureActionEncodingOn: writer within: requestContext ];
		createEntityTagHashing: [ :hasher :action :requestContext | 
			hasher
				include: ( self identifierOf: action );
				include: ( self lastModificationOf: action )
			];
		build
]

{ #category : #initialization }
ActionsRESTfulController >> initializeWorkingWith: aCosmosSystem [

	cosmos := aCosmosSystem.
	self initializeRequestHandler
]

{ #category : #'private - API' }
ActionsRESTfulController >> lastModificationOf: anAction [

	^ self timestampingSystem lastModificationOf: anAction
]

{ #category : #private }
ActionsRESTfulController >> requestHandler [
	
	^ requestHandler
]

{ #category : #'private - systems' }
ActionsRESTfulController >> timestampingSystem [
	
	^ cosmos >> #TimestampingSystemInterface
]

{ #category : #private }
ActionsRESTfulController >> typeIdConstraint [

	^ IsUUID
]
