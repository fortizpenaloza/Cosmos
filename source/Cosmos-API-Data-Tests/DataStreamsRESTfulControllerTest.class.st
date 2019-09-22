Class {
	#name : #DataStreamsRESTfulControllerTest,
	#superclass : #SystemBasedRESTfulControllerUserStoryTest,
	#category : #'Cosmos-API-Data-Tests'
}

{ #category : #tests }
DataStreamsRESTfulControllerTest >> assertDataStreamCreated [

	| dataStream |

	dataStream := self dataManagementSystem streamNamed: 'pH'.

	self
		assert: dataStream name equals: 'pH';
		assert: dataStream dataPoints isEmpty
]

{ #category : #'private - accessing' }
DataStreamsRESTfulControllerTest >> baseUrl [

	^ 'https://tests.cosmos.com' asZnUrl
]

{ #category : #'private - media types' }
DataStreamsRESTfulControllerTest >> dataPointVersion1dot0dot0MediaType [
	
	^ resourceController dataPointVersion1dot0dot0MediaType
]

{ #category : #'private - media types' }
DataStreamsRESTfulControllerTest >> dataStreamVersion1dot0dot0MediaType [

	^ resourceController dataStreamVersion1dot0dot0MediaType
]

{ #category : #'private - expected results' }
DataStreamsRESTfulControllerTest >> dataStreamsAsJSON [

	^ '{"items":[{"name":"Temperature","currentValue":16.5,"lastUpdate":"2014-10-01T12:00:00-03:00","links":{"dataPoints":"https://tests.cosmos.com/data-streams/ab203809-4537-0d00-96a8-67bd07fa2cfc/data-points","self":"https://tests.cosmos.com/data-streams/ab203809-4537-0d00-96a8-67bd07fa2cfc"}},{"name":"Pressure","currentValue":1016,"lastUpdate":"2014-10-01T12:00:00-03:00","links":{"dataPoints":"https://tests.cosmos.com/data-streams/c3e53a0a-4537-0d00-96a9-ad5f07fa2cfc/data-points","self":"https://tests.cosmos.com/data-streams/c3e53a0a-4537-0d00-96a9-ad5f07fa2cfc"}},{"name":"Humidity","currentValue":"N/A","lastUpdate":"N/A","links":{"dataPoints":"https://tests.cosmos.com/data-streams/6fbb430b-4537-0d00-96aa-582b07fa2cfc/data-points","self":"https://tests.cosmos.com/data-streams/6fbb430b-4537-0d00-96aa-582b07fa2cfc"}}],"links":{"self":"https://tests.cosmos.com/data-streams"}}'
]

{ #category : #'private - accessing' }
DataStreamsRESTfulControllerTest >> dateTimeFormattedAsISO8601 [

	^ ISO8601DateTimeFormatter usingExtendedFormat
		format: self systemDateTime
]

{ #category : #'private - accessing' }
DataStreamsRESTfulControllerTest >> identifierProvider [

	^ SequentialIdentifierProvider providing: self identifierSequence 
]

{ #category : #'private - accessing' }
DataStreamsRESTfulControllerTest >> identifierSequence [

	^ {self temperatureStreamIdentifier.
	(UUID fromString: 'c3e53a0a-4537-0d00-96a9-ad5f07fa2cfc').
	(UUID fromString: '6fbb430b-4537-0d00-96aa-582b07fa2cfc').
	(UUID fromString: '62ede40b-4537-0d00-96ab-a32d07fa2cfc')}
]

{ #category : #'private - requests' }
DataStreamsRESTfulControllerTest >> requestToCreateDataStreamFrom: aJSON [

	^ self requestToPost: aJSON as: self dataStreamVersion1dot0dot0MediaType
]

{ #category : #'private - requests' }
DataStreamsRESTfulControllerTest >> requestToDeleteStreamIdentifiedBy: anIdentifier [

	^ TeaRequest
		fromZnRequest: (
			ZnRequest delete: (self urlForResourceIdentifiedBy: anIdentifier))
		pathParams: {(#identifier -> anIdentifier)} asDictionary
]

{ #category : #'private - requests' }
DataStreamsRESTfulControllerTest >> requestToGetDataPointsOfDataStreamIdentifiedBy: anIdentifier accepting: aMediaType [

	^ TeaRequest
		fromZnRequest:
			((ZnRequest get: (self urlForResourceIdentifiedBy: anIdentifier) / 'data-points')
				setAccept: aMediaType;
				yourself)
		pathParams: {(#identifier -> anIdentifier)} asDictionary
]

{ #category : #'private - requests' }
DataStreamsRESTfulControllerTest >> requestToGetDataStreamIdentifiedBy: anIdentifier accepting: aMediaType [

	^ self requestToGetResourceIdentifiedBy: anIdentifier accepting: aMediaType
]

{ #category : #'private - requests' }
DataStreamsRESTfulControllerTest >> requestToGetDataStreamIdentifiedBy: anIdentifier accepting: aMediaType conditionalTo: anETag [

	^ TeaRequest
		fromZnRequest:
			((ZnRequest get: (self urlForResourceIdentifiedBy: anIdentifier))
				setAccept: aMediaType;
				setIfNoneMatchTo: anETag;
				yourself)
		pathParams: {(#identifier -> anIdentifier)} asDictionary
]

{ #category : #'private - requests' }
DataStreamsRESTfulControllerTest >> requestToGetDataStreamsAccepting: aMediaType [

	^ self requestToGetResourcesAccepting: aMediaType
]

{ #category : #running }
DataStreamsRESTfulControllerTest >> setUp [ 
	
	super setUp.
	(SensorsSampleAddOn on: rootSystem) install.

]

{ #category : #running }
DataStreamsRESTfulControllerTest >> setUpRequirements [

	self flag: 'requireDataManagementSystem'.
	self
		registerSubsystem: (TimeSystem using: (FixedTimeSource on: self systemDateTime));
		registerSubsystem: MetadataSystem new;
		registerSubsystem: (IdentifierSystem using: self identifierProvider);
		registerSubsystem: TimestampingSystem new;
		registerSubsystem: EventNotificationSystem new;
		registerSubsystem: DataStreamManagementSystem new.
	
 
]

{ #category : #running }
DataStreamsRESTfulControllerTest >> setUpResourceController [

	resourceController := DataStreamsRESTfulController workingWith: rootSystem.

]

{ #category : #'private - accessing' }
DataStreamsRESTfulControllerTest >> systemDateTime [

	^ DateTime 
		date: October first , 2014 
		timeOfDay: TimeOfDay noon 
		zone: TimeZones buenosAires
]

{ #category : #'private - accessing' }
DataStreamsRESTfulControllerTest >> temperatureStreamIdentifier [

	^ UUID fromString: 'ab203809-4537-0d00-96a8-67bd07fa2cfc'
]

{ #category : #tests }
DataStreamsRESTfulControllerTest >> testCreateDataStream [

	| response |

	response := resourceController
		createStreamBasedOn: ( self requestToCreateDataStreamFrom: '{"name":"pH"}' )
		within: self httpRequestContext.

	self
		assert: response isSuccess;
		assert: response code equals: 201;
		assertUrl: response location
			equals: 'https://tests.cosmos.com/data-streams/62ede40b-4537-0d00-96ab-a32d07fa2cfc';
		assert: response contentType equals: self dataStreamVersion1dot0dot0MediaType.
		
	self assertDataStreamCreated
]

{ #category : #tests }
DataStreamsRESTfulControllerTest >> testCreatingDataStreamFailsFromMalformattedRequest [

	self
		should: [ resourceController
				createStreamBasedOn: (self requestToCreateDataStreamFrom: '{"XXX":"Temperature"}')
				within: self httpRequestContext ]
		raise: HTTPClientError
		withExceptionDo: [ :signal | 
			self
				assert: signal messageText equals: 'key #name not found in Dictionary';
				assert: signal code equals: 400 ]
]

{ #category : #tests }
DataStreamsRESTfulControllerTest >> testCreatingDataStreamFailsFromUnsupportedMediaType [

	self
		should: [ resourceController
				createStreamBasedOn: (self requestToPost: '{"name":"Temperature"}' as: self unsupportedMediaType)
				within: self httpRequestContext ]
		raise: HTTPClientError
		withExceptionDo: [ :signal | 
			self
				assert: signal messageText equals: 'Decoder not found for given media type';
				assert: signal code equals: 415 ]
]

{ #category : #tests }
DataStreamsRESTfulControllerTest >> testCreatingDataStreamFailsIfAlreadyExists [

	self
		should: [ resourceController
				createStreamBasedOn: ( self requestToCreateDataStreamFrom: '{"name":"Temperature"}' )
				within: self httpRequestContext
			]
		raise: HTTPClientError
		withExceptionDo: [ :signal | 
			self
				assert: signal messageText
					equals: 'A data stream named ''Temperature'' already exists in system';
				assert: signal code equals: 409
			]
]

{ #category : #tests }
DataStreamsRESTfulControllerTest >> testDeleteDataStream [

	| response |

	self shouldnt: [ self dataManagementSystem streamNamed: 'Temperature' ] raise: ObjectNotFound.

	response := resourceController
		deleteStreamBasedOn: ( self requestToDeleteStreamIdentifiedBy: self temperatureStreamIdentifier )
		within: self httpRequestContext.

	self should: [ self dataManagementSystem streamNamed: 'Temperature' ] raise: ObjectNotFound.

	self
		assert: response isSuccess;
		assert: response status equals: 204;
		deny: response hasEntity
]

{ #category : #tests }
DataStreamsRESTfulControllerTest >> testDeletingDataStreamWithWrongIdentifierGivesNotFound [

	self
		should: [ resourceController
				deleteStreamBasedOn: (self requestToDeleteStreamIdentifiedBy: 1)
				within: self httpRequestContext ]
		raise: HTTPClientError
		withExceptionDo: [ :signal | 
			self
				assert: signal messageText equals: 'Data stream with that identifier not found';
				assert: signal code equals: 404 ]
]

{ #category : #tests }
DataStreamsRESTfulControllerTest >> testGetDataStream [

	| response |

	response := resourceController
		getStreamBasedOn:
			( self
				requestToGetDataStreamIdentifiedBy: self temperatureStreamIdentifier
				accepting: self dataStreamVersion1dot0dot0MediaType )
		within: self httpRequestContext.

	self
		assert: response isSuccess;
		assert: response status equals: 200;
		assert: response contentType equals: self dataStreamVersion1dot0dot0MediaType;
		assert: response entityTag equals: '"e6e4252fb2798ed7fe0058785a535db2a2ff7d06"' asETag;
		withJSONFromContentsIn: response contents
			do: [ :json | 
			self
				assert: json name equals: 'Temperature';
				assert: json currentValue equals: 16.5;
				assert: json lastUpdate equals: self dateTimeFormattedAsISO8601;
				assertUrl: json links self
					equals: 'https://tests.cosmos.com/data-streams/ab203809-4537-0d00-96a8-67bd07fa2cfc';
				assertUrl: json links dataPoints
					equals: 'https://tests.cosmos.com/data-streams/ab203809-4537-0d00-96a8-67bd07fa2cfc/data-points'
			]
]

{ #category : #tests }
DataStreamsRESTfulControllerTest >> testGetDataStreamDataPoints [

	| response |

	response := resourceController
		getPointsBasedOn:
			( self
				requestToGetDataPointsOfDataStreamIdentifiedBy: self temperatureStreamIdentifier
				accepting: self dataPointVersion1dot0dot0MediaType )
		within: self httpRequestContext.

	self
		assert: response isSuccess;
		assert: response status equals: 200;
		assert: response contentType equals: self dataPointVersion1dot0dot0MediaType;
		withJSONFromContentsIn: response
			do: [ :json | 
			self assert: json size equals: 3.
			self
				assert: json first timestamp equals: self dateTimeFormattedAsISO8601;
				assert: json first value equals: 16.5
			]
]

{ #category : #tests }
DataStreamsRESTfulControllerTest >> testGetDataStreams [

	| response |

	response := resourceController
		getStreamsBasedOn: ( self requestToGetDataStreamsAccepting: self dataStreamVersion1dot0dot0MediaType )
		within: self httpRequestContext.

	self
		assert: response isSuccess;
		assert: response status equals: 200;
		assert: response contentType equals: self dataStreamVersion1dot0dot0MediaType;
		assert: response contents equals: self dataStreamsAsJSON
]

{ #category : #tests }
DataStreamsRESTfulControllerTest >> testGetNotModifiedWhenValidETag [

	| response |

	response := resourceController
		getStreamBasedOn:
			( self
				requestToGetDataStreamIdentifiedBy: self temperatureStreamIdentifier
				accepting: self dataStreamVersion1dot0dot0MediaType )
		within: self httpRequestContext.

	self
		assert: response isSuccess;
		assert: response status equals: 200;
		assert: response entityTag equals: '"e6e4252fb2798ed7fe0058785a535db2a2ff7d06"' asETag.

	response := resourceController
		getStreamBasedOn:
			( self
				requestToGetDataStreamIdentifiedBy: self temperatureStreamIdentifier
				accepting: self dataStreamVersion1dot0dot0MediaType
				conditionalTo: '"e6e4252fb2798ed7fe0058785a535db2a2ff7d06"' asETag )
		within: self httpRequestContext.

	self
		assert: response status equals: 304;
		assert: response entityTag equals: '"e6e4252fb2798ed7fe0058785a535db2a2ff7d06"' asETag
]

{ #category : #tests }
DataStreamsRESTfulControllerTest >> testGettingDataStreamWithWrongIdentifierGivesNotFound [

	self
		should: [ resourceController
				getStreamBasedOn:
					( self requestToGetDataStreamIdentifiedBy: 1 accepting: self dataStreamVersion1dot0dot0MediaType )
				within: self httpRequestContext
			]
		raise: HTTPClientError
		withExceptionDo: [ :signal | 
			self
				assert: signal messageText equals: 'Data stream with that identifier not found';
				assert: signal code equals: 404
			]
]

{ #category : #'private - media types' }
DataStreamsRESTfulControllerTest >> textPlainMediaType [

	^ 'text/plain;charset=utf-8' asMediaType
]

{ #category : #'private - accessing' }
DataStreamsRESTfulControllerTest >> unsupportedMediaType [
	
	^ self textPlainMediaType 
]
