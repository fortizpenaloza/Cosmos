Class {
	#name : #DataPointsRESTfulController,
	#superclass : #ResourceRESTfulController,
	#instVars : [
		'cosmos',
		'requestHandler'
	],
	#category : #'Cosmos-API-Data'
}

{ #category : #'instance creation' }
DataPointsRESTfulController class >> workingWith: aCosmosSystem [
	
	^ self new initializeWorkingWith: aCosmosSystem
]

{ #category : #'private - media types' }
DataPointsRESTfulController >> applicationJSONVersion1dot0dot0MediaType [

	^ 'application/json;version=1.0.0' asMediaType
]

{ #category : #'private - encoding and decoding' }
DataPointsRESTfulController >> configureDataPointDecodingOn: aReader [

	^ aReader
		for: AddDataPoint
			customDo: [ :mapping | 
			mapping
				decoder: [ :dataPoint | 
					AddDataPoint
						adding: ( DataPoint on: self dateTime holding: ( dataPoint at: #value ) )
						toStreamNamed: ( dataPoint at: #dataStream )
						on: self dataManagementSystem
					]
			];
		for: #Collection
			customDo: [ :mapping | mapping listOfType: OrderedCollection andElementSchema: AddDataPoint ];
		nextAs: #Collection
]

{ #category : #'private - encoding and decoding' }
DataPointsRESTfulController >> configureDataPointEncodingOn: aWriter [

	aWriter for: AddDataPoint do: [ :mapping | ]
]

{ #category : #API }
DataPointsRESTfulController >> createPointsBasedOn: anHttpRequest within: aRequestContext [

	^ self requestHandler
		withResourceCreatedFrom: anHttpRequest
		within: aRequestContext
		do: [ :addDataPointSet | 
			addDataPointSet
				do:
					[ :addDataPoint | self dataManagementSystem register: addDataPoint dataPoint to: addDataPoint dataStream ]
			]
]

{ #category : #'private - systems' }
DataPointsRESTfulController >> dataManagementSystem [

	^ cosmos systemImplementing: #DataStreamManagementSystemInterface
]

{ #category : #private }
DataPointsRESTfulController >> dateTime [

	^ self timeSystem dateTime
]

{ #category : #routes }
DataPointsRESTfulController >> declareCreateDataPointsRoute [

	^ ( RouteSpecification
		handling: #POST
		at: self endpoint
		evaluating: [ :httpRequest :httpContext | self createPointsBasedOn: httpRequest within: httpContext ] )
		asCorsAware
]

{ #category : #accessing }
DataPointsRESTfulController >> endpoint [

	^ self requestHandler endpoint
]

{ #category : #initialization }
DataPointsRESTfulController >> initializeRequestHandler [

	requestHandler := RESTfulRequestHandlerBuilder new
		handling: 'data-points'
			locatingResourcesWith: [ :action :requestContext | '' ]
			extractingIdentifierWith: [ :httpRequest | '' ];
		handleExceptionsApplying: [ :handler | handler addAsDecodingError: ObjectNotFound ];
		whenAccepting: self applicationJSONVersion1dot0dot0MediaType
			decodeFromJsonApplying: [ :json :reader | self configureDataPointDecodingOn: reader ];
		whenResponding: self applicationJSONVersion1dot0dot0MediaType
			encodeToJsonApplying: [ :resource :requestContext :writer | self configureDataPointEncodingOn: writer ];
		createEntityTagHashing: [ :hasher :action :requestContext |  ];
		build
]

{ #category : #initialization }
DataPointsRESTfulController >> initializeWorkingWith: aCosmosSystem [

	cosmos := aCosmosSystem.
	self initializeRequestHandler
]

{ #category : #private }
DataPointsRESTfulController >> requestHandler [

	^ requestHandler 
]

{ #category : #configuring }
DataPointsRESTfulController >> serverUrl: aServerUrl [

	self requestHandler serverUrl: aServerUrl
]

{ #category : #'private - systems' }
DataPointsRESTfulController >> timeSystem [
	
	^ cosmos systemImplementing: #TimeSystemInterface
]
