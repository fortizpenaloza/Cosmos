Class {
	#name : #DataStreamsRESTfulController,
	#superclass : #SingleResourceRESTfulController,
	#instVars : [
		'cosmos',
		'requestHandler',
		'dataPointsRequestHandler'
	],
	#category : #'Cosmos-API-Data'
}

{ #category : #'instance creation' }
DataStreamsRESTfulController class >> workingWith: aCosmosSystem [
	
	^ self new initializeWorkingWith: aCosmosSystem
]

{ #category : #'private - encoding and decoding' }
DataStreamsRESTfulController >> configureDataStreamDecodingOn: aReader [

	^ aReader
		for: DataStream
			customDo: [ :mapping | mapping decoder: [ :rawStream | DataStream named: ( rawStream at: #name ) ] ];
		nextAs: DataStream
]

{ #category : #'private - encoding and decoding' }
DataStreamsRESTfulController >> configureDataStreamEncodingOn: aWriter within: aRequestContext [

	aWriter
		for: DataStream
		do: [ :mapping | 
			mapping
				mapAccessor: #name;
				mapProperty: #currentValue
					getter: [ :dataStream | 
					[ dataStream currentValue ]
						on: DataStreamIsEmpty
						do: [ :signal | signal return: 'N/A' ]
					];
				mapProperty: #lastUpdate
					getter: [ :dataStream | 
					[ dataStream lastUpdate ]
						on: DataStreamIsEmpty
						do: [ :signal | signal return: 'N/A' ]
					];
				mapAsHypermediaControls: [ :dataStream | aRequestContext hypermediaControlsFor: dataStream ]
			]
]

{ #category : #API }
DataStreamsRESTfulController >> createStreamBasedOn: anHttpRequest within: aContext [

	^ self requestHandler
		withResourceCreatedFrom: anHttpRequest
		within: aContext
		do: [ :dataStream | self dataManagementSystem register: dataStream ]
]

{ #category : #'private - systems' }
DataStreamsRESTfulController >> dataManagementSystem [

	^ cosmos systemImplementing: #DataStreamManagementSystemInterface
]

{ #category : #'private - media types' }
DataStreamsRESTfulController >> dataPointVersion1dot0dot0MediaType [

	^ self jsonMediaType: 'data-point' vendoredBy: 'cosmos' version: '1.0.0'
]

{ #category : #'private - API' }
DataStreamsRESTfulController >> dataPointsForDataStreamIn: anHttpRequest [

	^ ( self dataManagementSystem streamIdentifiedBy: ( self identifierIn: anHttpRequest ) ) dataPoints
]

{ #category : #private }
DataStreamsRESTfulController >> dataPointsTemplate [

	^ '<1s><2s>' expandMacrosWith: self identifierTemplate with: dataPointsRequestHandler endpoint
]

{ #category : #'private - media types' }
DataStreamsRESTfulController >> dataStreamVersion1dot0dot0MediaType [

	^ self jsonMediaType: 'data-stream' vendoredBy: 'cosmos' version: '1.0.0'
]

{ #category : #routes }
DataStreamsRESTfulController >> declareCreateDataStreamRoute [

	^ ( RouteSpecification
		handling: #POST
		at: self endpoint
		evaluating: [ :httpRequest :requestContext | self createStreamBasedOn: httpRequest within: requestContext ] )
		asCorsAware
]

{ #category : #routes }
DataStreamsRESTfulController >> declareDeleteDataStreamRoute [

	^ ( RouteSpecification
		handling: #DELETE
		at: self identifierTemplate
		evaluating: [ :httpRequest :requestContext | self deleteStreamBasedOn: httpRequest within: requestContext ] )
		asCorsAware
]

{ #category : #routes }
DataStreamsRESTfulController >> declareGetDataPointsRoute [

	^ RouteSpecification
		handling: #GET
		at: self dataPointsTemplate
		evaluating: [ :httpRequest :requestContext | self getPointsBasedOn: httpRequest within: requestContext ]
]

{ #category : #API }
DataStreamsRESTfulController >> deleteStreamBasedOn: anHttpRequest within: aContext [

	^ self requestHandler
		from: anHttpRequest
		within: aContext
		get: [ :id | self dataManagementSystem streamIdentifiedBy: id ]
		thenDo: [ :dataStream | self dataManagementSystem deregister: dataStream ]
]

{ #category : #routes }
DataStreamsRESTfulController >> getDataStreamRoute [

	^ RouteSpecification
		handling: #GET
		at: self identifierTemplate
		evaluating: [ :httpRequest :requestContext | self getStreamBasedOn: httpRequest within: requestContext ]
]

{ #category : #routes }
DataStreamsRESTfulController >> getDataStreamsRoute [

	^ RouteSpecification
		handling: #GET
		at: self endpoint
		evaluating: [ :httpRequest :requestContext | self getStreamsBasedOn: httpRequest within: requestContext ]
]

{ #category : #API }
DataStreamsRESTfulController >> getPointsBasedOn: anHttpRequest within: aRequestContext [

	^ dataPointsRequestHandler
		from: anHttpRequest
		within: aRequestContext
		getCollection: [ self dataPointsForDataStreamIn: anHttpRequest ]
]

{ #category : #API }
DataStreamsRESTfulController >> getStreamBasedOn: anHttpRequest within: aContext [

	^ self requestHandler
		from: anHttpRequest
		within: aContext
		get: [ :identifier | self dataManagementSystem streamIdentifiedBy: identifier ]
]

{ #category : #API }
DataStreamsRESTfulController >> getStreamsBasedOn: anHttpRequest within: aContext [

	^ self requestHandler
		from: anHttpRequest
		within: aContext
		getCollection: [ self dataManagementSystem streams ]
]

{ #category : #'private - API' }
DataStreamsRESTfulController >> identifierOf: aDataStream [

	^ self identifierSystem identifierOf: aDataStream
]

{ #category : #'private - systems' }
DataStreamsRESTfulController >> identifierSystem [

	^ cosmos systemImplementing: #IdentifierSystemInterface
]

{ #category : #initialization }
DataStreamsRESTfulController >> initializeDataPointsRequestHandler [

	dataPointsRequestHandler := RESTfulRequestHandlerBuilder new
		handling: 'data-points'
			extractingIdentifierWith: [ :httpRequest | self identifierIn: httpRequest ]
			locatingParentResourceWith: requestHandler resourceLocator;
		whenResponding: self dataPointVersion1dot0dot0MediaType
			encodeToJsonApplying:
				[ :resource :requestContext :writer | writer for: DataPoint do: [ :mapping | mapping mapAccessors: #(timestamp value) ] ];
		createEntityTagHashing: [ :hasher :comment :requestContext | hasher include: comment ];
		build
]

{ #category : #initialization }
DataStreamsRESTfulController >> initializeRequestHandler [

	requestHandler := RESTfulRequestHandlerBuilder new
		handling: 'data-streams'
			locatingResourcesWith: [ :action :requestContext | self identifierOf: action ]
			extractingIdentifierWith: [ :httpRequest | self identifierIn: httpRequest ];
		beHypermediaDrivenBy:
				[ :builder :dataStream :requestContext :location | builder addLink: location / 'data-points' asUrl relatedTo: 'dataPoints' ];
		whenAccepting: self dataStreamVersion1dot0dot0MediaType
			decodeFromJsonApplying: [ :json :reader | self configureDataStreamDecodingOn: reader ];
		whenResponding: self dataStreamVersion1dot0dot0MediaType
			encodeToJsonApplying:
				[ :resource :requestContext :writer | self configureDataStreamEncodingOn: writer within: requestContext ];
		createEntityTagHashing: [ :hasher :action :requestContext | 
			hasher
				include: ( self identifierOf: action );
				include: ( self lastModificationOf: action )
			];
		build
]

{ #category : #initialization }
DataStreamsRESTfulController >> initializeWorkingWith: aCosmosSystem [

	cosmos := aCosmosSystem.
	self
		initializeRequestHandler;
		initializeDataPointsRequestHandler
]

{ #category : #'private - API' }
DataStreamsRESTfulController >> lastModificationOf: aDataStream [

	^ self timestampingSystem lastModificationOf: aDataStream
]

{ #category : #private }
DataStreamsRESTfulController >> requestHandler [

	^ requestHandler
]

{ #category : #'private - systems' }
DataStreamsRESTfulController >> timestampingSystem [

	^ cosmos systemImplementing: #TimestampingSystemInterface
]

{ #category : #private }
DataStreamsRESTfulController >> typeIdConstraint [

	^ IsUUID
]
