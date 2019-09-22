Class {
	#name : #CommandsRESTfulController,
	#superclass : #SingleResourceRESTfulController,
	#instVars : [
		'cosmos',
		'requestHandler',
		'nextCommandRequestHandler'
	],
	#category : #'Cosmos-API-Commands'
}

{ #category : #'instance creation' }
CommandsRESTfulController class >> workingWith: aCosmosSystem [
	
	^ self new initializeWorkingWith: aCosmosSystem
]

{ #category : #'private - systems' }
CommandsRESTfulController >> commandManagementSystem [

	^ cosmos >> #CommandManagementSystemInterface
]

{ #category : #'private - media types' }
CommandsRESTfulController >> commandVersion1dot0dot0MediaType [

	^ self jsonMediaType: 'command' vendoredBy: 'cosmos' version: '1.0.0'
]

{ #category : #'private - API' }
CommandsRESTfulController >> commandsOrderedAccordingTo: orderingPolicy [

	^ orderingPolicy = 'priority'
		ifTrue: [ self commandManagementSystem prioritizedCommands ]
		ifFalse: [ self commandManagementSystem commands ]
]

{ #category : #'private - API' }
CommandsRESTfulController >> commandsOrderedAsRequestedIn: anHttpRequest [

	^ self
		withOrderingPolicyRequestedIn: anHttpRequest
		do: [ :orderingPolicy | self commandsOrderedAccordingTo: orderingPolicy ]
]

{ #category : #'private - encoding and decoding' }
CommandsRESTfulController >> configureCommandDecodingOn: aReader [

	^ aReader
		for: CommandWithPriority
			customDo: [ :mapping | 
			mapping
				decoder:
					[ :rawCommand | CommandWithPriority holding: ( rawCommand at: #command ) and: ( rawCommand at: #priority ) ]
			];
		nextAs: CommandWithPriority
]

{ #category : #'private - encoding and decoding' }
CommandsRESTfulController >> configureCommandEncodingOn: aWriter within: aRequestContext [

	aWriter
		for: CommandWithPriority
		do: [ :mapping | 
			mapping
				mapAccessor: #command;
				mapAccessor: #priority;
				mapAsHypermediaControls: [ :commandWithPriority | aRequestContext hypermediaControlsFor: commandWithPriority ]
			]
]

{ #category : #API }
CommandsRESTfulController >> createCommandBasedOn: anHttpRequest within: aContext [

	^ self requestHandler
		withResourceCreatedFrom: anHttpRequest
		within: aContext
		do: [ :commandWithPriority | self commandManagementSystem register: commandWithPriority ]
]

{ #category : #routes }
CommandsRESTfulController >> declareCreateCommandsRoute [

	^ ( RouteSpecification
		handling: #POST
		at: self endpoint
		evaluating: [ :httpRequest :requestContext | self createCommandBasedOn: httpRequest within: requestContext ] )
		asCorsAware
]

{ #category : #routes }
CommandsRESTfulController >> declareDeleteCommandsRoute [

	^ ( RouteSpecification
		handling: #DELETE
		at: self identifierTemplate
		evaluating: [ :httpRequest :requestContext | self deleteCommandBasedOn: httpRequest within: requestContext ] )
		asCorsAware
]

{ #category : #routes }
CommandsRESTfulController >> declareGetCommandRoute [

	^ RouteSpecification
		handling: #GET
		at: self identifierTemplate
		evaluating: [ :httpRequest :requestContext | self getCommandsBasedOn: httpRequest within: requestContext ]
]

{ #category : #routes }
CommandsRESTfulController >> declareGetCommandsRoute [

	^ RouteSpecification
		handling: #GET
		at: self endpoint
		evaluating: [ :httpRequest :requestContext | self getCommandsBasedOn: httpRequest within: requestContext ]
]

{ #category : #routes }
CommandsRESTfulController >> declareNextCommandRoute [

	^ RouteSpecification
		handling: #POST
		at: self nextCommandTemplate 
		evaluating: [ :httpRequest :requestContext | self nextCommandBasedOn: httpRequest within: requestContext ]
]

{ #category : #API }
CommandsRESTfulController >> deleteCommandBasedOn: anHTTPRequest within: aRequestContext [

	^ self requestHandler
		from: anHTTPRequest
		within: aRequestContext
		get: [ :identifier | self commandManagementSystem commandIdentifiedBy: identifier ]
		thenDo: [ :action | self commandManagementSystem deregister: action ]
]

{ #category : #API }
CommandsRESTfulController >> getCommandBasedOn: anHttpRequest within: aContext [

	^ self requestHandler 
		from: anHttpRequest 
		within: aContext
		get: [ :identifier | self commandManagementSystem commandIdentifiedBy: identifier ]
]

{ #category : #API }
CommandsRESTfulController >> getCommandsBasedOn: anHttpRequest within: aContext [

	^ self requestHandler
		from: anHttpRequest
		within: aContext
		getCollection: [ self commandsOrderedAsRequestedIn: anHttpRequest ]
]

{ #category : #'private - API' }
CommandsRESTfulController >> identifierOf: aCommandWithPriority [

	^ self identifierSystem identifierOf: aCommandWithPriority
]

{ #category : #'private - systems' }
CommandsRESTfulController >> identifierSystem [

	^ cosmos >> #IdentifierSystemInterface
]

{ #category : #initialization }
CommandsRESTfulController >> initializeNextCommandRequestHandler [

	nextCommandRequestHandler := RESTfulRequestHandlerBuilder new
		handling: 'commands'
			locatingResourcesWith: [ :commandWithPriority :requestContext | self identifierOf: commandWithPriority ]
			extractingIdentifierWith: [ :httpRequest | ];
		beHypermediaDriven;
		whenResponding: self commandVersion1dot0dot0MediaType
			encodeToJsonApplying:
				[ :commandWithPriority :requestContext :writer | self configureCommandEncodingOn: writer within: requestContext ];
		whenResponding: ZnMimeType textPlain
			encodeApplying: [ :commandWithPriority | commandWithPriority command ];
		createEntityTagHashing: [ :hasher :action :requestContext | 
			hasher
				include: ( self identifierOf: action );
				include: ( self lastModificationOf: action )
			];
		build
]

{ #category : #initialization }
CommandsRESTfulController >> initializeRequestHandler [

	requestHandler := RESTfulRequestHandlerBuilder new
		handling: 'commands'
			locatingResourcesWith: [ :command :requestContext | self identifierOf: command ]
			extractingIdentifierWith: [ :httpRequest | self identifierIn: httpRequest ];
		beHypermediaDriven;
		whenAccepting: self commandVersion1dot0dot0MediaType
			decodeFromJsonApplying: [ :json :reader | self configureCommandDecodingOn: reader ];
		whenResponding: self commandVersion1dot0dot0MediaType
			encodeToJsonApplying:
				[ :resource :requestContext :writer | self configureCommandEncodingOn: writer within: requestContext ];
		createEntityTagHashing: [ :hasher :action :requestContext | 
			hasher
				include: ( self identifierOf: action );
				include: ( self lastModificationOf: action )
			];
		build
]

{ #category : #initialization }
CommandsRESTfulController >> initializeWorkingWith: aCosmosSystem [

	cosmos := aCosmosSystem.
	self
		initializeRequestHandler;
		initializeNextCommandRequestHandler
]

{ #category : #'private - API' }
CommandsRESTfulController >> lastModificationOf: aCommandWithPriority [

	^ self timestampingSystem lastModificationOf: aCommandWithPriority
]

{ #category : #API }
CommandsRESTfulController >> nextCommandBasedOn: anHttpRequest within: aRequestContext [

	^ nextCommandRequestHandler
		from: anHttpRequest
		within: aRequestContext
		get: [ self commandManagementSystem nextCommand ]
]

{ #category : #private }
CommandsRESTfulController >> nextCommandTemplate [

	^ '<1s>/next' expandMacrosWith: self endpoint
	
]

{ #category : #private }
CommandsRESTfulController >> requestHandler [
	
	^ requestHandler
]

{ #category : #private }
CommandsRESTfulController >> serverUrl: aServerUrl [

	super serverUrl: aServerUrl.
	nextCommandRequestHandler serverUrl: aServerUrl
]

{ #category : #'private - systems' }
CommandsRESTfulController >> timestampingSystem [

	^ cosmos >> #TimestampingSystemInterface
]

{ #category : #private }
CommandsRESTfulController >> typeIdConstraint [

	^ IsUUID
]

{ #category : #'private - API' }
CommandsRESTfulController >> withOrderingPolicyRequestedIn: anHttpRequest do: aBlock [

	^ aBlock
		value: (anHttpRequest at: #order ifAbsent: [ 'registration' ])
]
