Class {
	#name : #DataAPITest,
	#superclass : #RESTfulAPIUserStoryTest,
	#instVars : [
		'dataStreamsController',
		'dataPointsController'
	],
	#category : #'Cosmos-API-Data-Tests'
}

{ #category : #running }
DataAPITest >> controllersToInstall [

	dataStreamsController := DataStreamsRESTfulController workingWith: rootSystem.
	dataPointsController := DataPointsRESTfulController workingWith: rootSystem.

	^ {dataStreamsController.
	dataPointsController}
]

{ #category : #running }
DataAPITest >> setUpRequirements [

	self
		registerSubsystem: ( TimeSystem using: ( FixedTimeSource on: self systemDateTime ) );
		registerSubsystem: MetadataSystem new;
		registerSubsystem: ( IdentifierSystem using: self identifierProvider );
		registerSubsystem: TimestampingSystem new;
		registerSubsystem: EventNotificationSystem new;
		registerSubsystem: DataStreamManagementSystem new
]

{ #category : #running }
DataAPITest >> testCORSAwareRoutes [

	| response |

	api beCORSAwareAllowing: {self baseUrl}.
	response := self newClient
		url: self baseUrl / dataStreamsController endpoint;
		headerAt: 'Access-Control-Request-Method' put: 'POST';
		headerAt: 'Access-Control-Request-Headers' put: 'Origin';
		headerAt: 'Origin' put: self baseUrl asString;
		options;
		response.

	self
		assert: ( response headers at: 'Vary' ) equals: 'Origin';
		assert: ( response headers at: 'Access-Control-Allow-Origin' ) asUrl equals: self baseUrl;
		assert: ( response headers at: 'Access-Control-Allow-Headers' )
			equals: 'Access-Control-Allow-Origin, Content-Type, Accept';
		assert: ( response headers at: 'Access-Control-Allow-Methods' ) equals: 'POST'.

	self
		withCreatedDataStreamLocationDo: [ :location | 
			response := self newClient
				url: location;
				headerAt: 'Access-Control-Request-Method' put: 'DELETE';
				headerAt: 'Access-Control-Request-Headers' put: 'Origin';
				headerAt: 'Origin' put: self baseUrl asString;
				options;
				response.

			self
				assert: ( response headers at: 'Vary' ) equals: 'Origin';
				assert: ( response headers at: 'Access-Control-Allow-Origin' ) asUrl equals: self baseUrl;
				assert: ( response headers at: 'Access-Control-Allow-Headers' )
					equals: 'Access-Control-Allow-Origin, Content-Type, Accept';
				assert: ( response headers at: 'Access-Control-Allow-Methods' ) equals: 'DELETE'
			]
]

{ #category : #tests }
DataAPITest >> testCreateDataStream [

	self
		withCreatedDataStreamResponseDo: [ :response | 
			self
				assert: response isSuccess;
				assert: response code equals: 201
			]
]

{ #category : #tests }
DataAPITest >> testDeleteDataStream [

	| response |

	self
		withCreatedDataStreamLocationDo: [ :location | 
			response := self newClient
				url: location;
				delete;
				response.

			self
				assert: response isSuccess;
				assert: response code equals: 204;
				deny: response hasEntity
			]
]

{ #category : #tests }
DataAPITest >> testGetDataStream [

	| response |

	self
		withCreatedDataStreamLocationDo: [ :location | 
			response := self newClient
				url: location;
				get;
				response.

			self
				assert: response isSuccess;
				assert: response code equals: 200;
				assert: response hasEntity
			]
]

{ #category : #tests }
DataAPITest >> testGetDataStreams [

	| response |

	response := self newClient
		url: self baseUrl / dataStreamsController endpoint;
		get;
		response.

	self
		assert: response isSuccess;
		assert: response code equals: 200;
		assert: response hasEntity
		
]

{ #category : #'tests - support' }
DataAPITest >> withCreatedDataStreamLocationDo: aBlock [

	self withCreatedDataStreamResponseDo: [ :response | aBlock value: response location ]
]

{ #category : #'tests - support' }
DataAPITest >> withCreatedDataStreamResponseDo: aBlock [

	| response |

	response := self newClient
		url: self baseUrl / dataStreamsController endpoint;
		entity: ( ZnEntity with: '{"name":"pH"}' ofType: dataStreamsController dataStreamVersion1dot0dot0MediaType );
		post;
		response.

	aBlock value: response
]
