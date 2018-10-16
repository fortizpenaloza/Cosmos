Class {
	#name : #DataRESTfulWebServiceTest,
	#superclass : #SystemBasedUserStoryTest,
	#instVars : [
		'interface',
		'identifierSequence'
	],
	#category : #'Cosmos-API-Data-Tests'
}

{ #category : #'accessing - media types' }
DataRESTfulWebServiceTest >> applicationJsonVersion1dot0dot0 [

	^ ZnMimeType fromString: 'application/json;version=1.0.0'
]

{ #category : #'expected results' }
DataRESTfulWebServiceTest >> dataStreamsSnapshotAsJSON [

	^ '[{"name":"Temperature","current_value":16.5,"last_update":"<1s>","metadata":[{"identifier":"<2p>"},{"registration_timestamp":"<1s>"}]},{"name":"Pressure","current_value":1016,"last_update":"<1s>","metadata":[{"identifier":"<3p>"},{"registration_timestamp":"<1s>"}]},{"name":"Humidity","current_value":"N/A","last_update":"N/A","metadata":[{"identifier":"<4p>"},{"registration_timestamp":"<1s>"}]}]'
		expandMacrosWith: self dateTimeFormattedAsISO8601
		with: self temperatureStreamIdentifier
		with: identifierSequence second
		with: identifierSequence third
]

{ #category : #accessing }
DataRESTfulWebServiceTest >> dateTimeFormattedAsISO8601 [

	^ ISO8601DateTimeFormatter usingExtendedFormat
		format: self systemDateTime
]

{ #category : #accessing }
DataRESTfulWebServiceTest >> httpRequestContext [

	^ HttpRequestContext new
]

{ #category : #accessing }
DataRESTfulWebServiceTest >> identifierProvider [

	^ SequentialIdentifierProvider providing: identifierSequence 
]

{ #category : #accessing }
DataRESTfulWebServiceTest >> pressureStream [

	^ self dataManagementSystem
		streamNamed: 'Pressure'
		ifFound: [ :dataStream | dataStream ]
		ifNone: [ "do nothing" ]
]

{ #category : #'accessing - requests' }
DataRESTfulWebServiceTest >> requestToCreateDataStreamFrom: aReprensentation [

	^ self
		requestToCreateDataStreamFrom: aReprensentation
		encodedAs: self applicationJsonVersion1dot0dot0
]

{ #category : #'accessing - requests' }
DataRESTfulWebServiceTest >> requestToCreateDataStreamFrom: aRepresentation encodedAs: aMediaType [

	^ (ZnRequest post: 'http://COSMOS_URL/data-streams')
		entity: (ZnEntity with: aRepresentation type: aMediaType)
]

{ #category : #'accessing - requests' }
DataRESTfulWebServiceTest >> requestToCreateTemperatureAndPressureDataPoints [

	^ (ZnRequest post: 'http://COSMOS_URL/data-points')
		entity:
			(ZnEntity
				with:
					'[
			{
				"data_stream" : "Temperature",
				"value" : 24
			},
			{
				"data_stream" : "Pressure",
				"value" : 89
			}
		]'
				type: self applicationJsonVersion1dot0dot0)
]

{ #category : #'accessing - requests' }
DataRESTfulWebServiceTest >> requestToDeleteTemperatureStreamIdentifiedBy: anIdentifier [

	^ TeaRequest
		fromZnRequest: (ZnRequest delete: 'http://COSMOS_URL/data-streams')
		pathParams: {(#identifier -> anIdentifier)} asDictionary
]

{ #category : #'accessing - requests' }
DataRESTfulWebServiceTest >> requestToGetDataPointsOfDataStreamIdentifiedBy: anIdentifier [

	^ TeaRequest
		fromZnRequest:
			((ZnRequest get: 'http://COSMOS_URL/data-streams/' , anIdentifier asString , '/data-points')
				setAccept: self applicationJsonVersion1dot0dot0)
		pathParams: {(#identifier -> anIdentifier)} asDictionary
]

{ #category : #'accessing - requests' }
DataRESTfulWebServiceTest >> requestToGetDataStreamIdentifiedBy: anIdentifier [

	^ TeaRequest
		fromZnRequest:
			((ZnRequest get: 'http://COSMOS_URL/data-streams/')
				setAccept: self applicationJsonVersion1dot0dot0)
		pathParams: {(#identifier -> anIdentifier)} asDictionary
]

{ #category : #'accessing - requests' }
DataRESTfulWebServiceTest >> requestToGetDataStreams [

	^ TeaRequest
		fromZnRequest:
			((ZnRequest get: 'http://COSMOS_URL/data-streams')
				setAccept: self applicationJsonVersion1dot0dot0)
]

{ #category : #running }
DataRESTfulWebServiceTest >> setUp [

	identifierSequence := {UUID new.
	UUID new.
	UUID new.
	UUID new}.

	super setUp.

	interface := DataRESTfulWebService workingWith: rootSystem.
	 		
	(SensorsSampleAddOn on: rootSystem) install
]

{ #category : #running }
DataRESTfulWebServiceTest >> setUpRequirements [

	super
		setUpRequirements;
		requireDataManagementSystem.
 
]

{ #category : #'expected results' }
DataRESTfulWebServiceTest >> temperatureDataStreamAsJSON [

	^ '{"name":"Temperature","current_value":16.5,"last_update":"<1s>","metadata":[{"identifier":"<2p>"},{"registration_timestamp":"<1s>"}]}'
		expandMacrosWith: self dateTimeFormattedAsISO8601
		with: self temperatureStreamIdentifier
]

{ #category : #accessing }
DataRESTfulWebServiceTest >> temperatureStream [

	^ self dataManagementSystem
		streamNamed: 'Temperature'
		ifFound: [ :dataStream | dataStream ]
		ifNone: [ "do nothing" ]
]

{ #category : #accessing }
DataRESTfulWebServiceTest >> temperatureStreamIdentifier [

	^ identifierSequence first
]

{ #category : #tests }
DataRESTfulWebServiceTest >> testCreateDataPoints [

	| response temperature pressure |

	temperature := self temperatureStream.
	pressure := self pressureStream.

	self deny: temperature currentValue = 24.
	self deny: pressure currentValue = 89.

	response := interface
		createBulkPointsBasedOn: self requestToCreateTemperatureAndPressureDataPoints
		within: self httpRequestContext.

	self
		assert: response isSuccess;
		assert: response code equals: 201;
		assert: response location equals: 'multiple';
		assert: response hasEntity;
		assert: temperature currentValue = 24;
		assert: pressure currentValue = 89
]

{ #category : #tests }
DataRESTfulWebServiceTest >> testCreateDataStream [

	| response |

	self dataManagementSystem
		streamNamed: 'pH'
		ifFound: [ :dataStream | self fail ]
		ifNone: [ "do nothing" ].

	response := interface
		createStreamBasedOn: (self requestToCreateDataStreamFrom: '{"name":"pH"}')
		within: self httpRequestContext.

	self
		assert: response isSuccess;
		assert: response code equals: 201;
		assert: response location
			equals: '/data-stream/' , identifierSequence last asString;
		assert: response contentType equals: ZnMimeType textPlain.

	self dataManagementSystem
		streamNamed: 'pH'
		ifFound: [ :dataStream | 
			self
				assert: dataStream name equals: 'pH';
				assert: dataStream dataPoints isEmpty ]
		ifNone: [ self fail ]
]

{ #category : #tests }
DataRESTfulWebServiceTest >> testCreatingDataPointsFailsFromMalformattedRequest [

	self
		should: [ interface
				createBulkPointsBasedOn: self updateTemperatureAndPressureDataStreamsMalformattedRequest
				within: self httpRequestContext ]
		raise: HTTPClientError
		withDescription: 'Data stream not found in the system'
]

{ #category : #tests }
DataRESTfulWebServiceTest >> testCreatingDataStreamFailsFromMalformattedRequest [

	self
		should: [ interface
				createStreamBasedOn: (self requestToCreateDataStreamFrom: '{"XXX":"Temperature"}')
				within: self httpRequestContext ]
		raise: HTTPClientError
		withExceptionDo: [ :signal | 
			self
				assert: signal messageText equals: 'Expected key name was not found';
				assert: signal code equals: 400 ]
]

{ #category : #tests }
DataRESTfulWebServiceTest >> testCreatingDataStreamFailsFromUnsuportedMediaType [

	self
		should: [ interface
				createStreamBasedOn:
					(self requestToCreateDataStreamFrom: '{"name":"Temperature"}' encodedAs: self textPlain)
				within: self httpRequestContext ]
		raise: HTTPClientError
		withExceptionDo: [ :signal | 
			self
				assert: signal messageText equals: 'Decoder not found for given media type';
				assert: signal code equals: 415 ]
]

{ #category : #tests }
DataRESTfulWebServiceTest >> testCreatingDataStreamFailsIfAlreadyExists [

	self
		should: [ interface
				createStreamBasedOn: (self requestToCreateDataStreamFrom: '{"name":"Temperature"}')
				within: self httpRequestContext ]
		raise: HTTPClientError
		withExceptionDo: [ :signal | 
			self
				assert: signal messageText equals: 'A data stream with that name already exists in system';
				assert: signal code equals: 409 ]
]

{ #category : #tests }
DataRESTfulWebServiceTest >> testDeleteDataStream [

	| response |

	self dataManagementSystem
		streamNamed: 'Temperature'
		ifFound: [ :dataStream | "do nothing" ]
		ifNone: [ self fail ].

	response := interface
		deleteStreamBasedOn:
			(self
				requestToDeleteTemperatureStreamIdentifiedBy: self temperatureStreamIdentifier)
		within: self httpRequestContext.

	self dataManagementSystem
		streamNamed: 'Temperature'
		ifFound: [ :dataStream | self fail ]
		ifNone: [ "do nothing" ].

	self
		assert: response isSuccess;
		assert: response status equals: 204;
		deny: response hasEntity
]

{ #category : #tests }
DataRESTfulWebServiceTest >> testDeletingDataStreamWithWrongIdentifierGivesNotFound [

	self
		should: [ interface
				deleteStreamBasedOn: (self requestToDeleteTemperatureStreamIdentifiedBy: 1)
				within: self httpRequestContext ]
		raise: HTTPClientError
		withExceptionDo: [ :signal | 
			self
				assert: signal messageText equals: 'Data stream with that identifier not found';
				assert: signal code equals: 404 ]
]

{ #category : #tests }
DataRESTfulWebServiceTest >> testGetDataStream [

	| response |

	response := interface
		getStreamsBasedOn: (self requestToGetDataStreamIdentifiedBy: self temperatureStreamIdentifier)
		within: self httpRequestContext.

	self
		assert: response isSuccess;
		assert: response code equals: 200;
		assert: response contentType equals: self applicationJsonVersion1dot0dot0;
		assert: response contents equals: self temperatureDataStreamAsJSON
]

{ #category : #tests }
DataRESTfulWebServiceTest >> testGetDataStreamDataPoints [

	| response |

	response := interface
		getPointsBasedOn:
			(self
				requestToGetDataPointsOfDataStreamIdentifiedBy: self temperatureStreamIdentifier)
		within: self httpRequestContext.

	self
		assert: response code equals: 200;
		assert: response contents
			equals:
			('[{"timestamp":"<1s>","value":16.5},{"timestamp":"<1s>","value":16},{"timestamp":"<1s>","value":15.5}]'
				expandMacrosWith: self dateTimeFormattedAsISO8601)
]

{ #category : #tests }
DataRESTfulWebServiceTest >> testGetDataStreams [

	| response |

	response := interface
		getStreamsBasedOn: self requestToGetDataStreams
		within: self httpRequestContext.

	self
		assert: response isSuccess;
		assert: response code equals: 200;
		assert: response contentType equals: self applicationJsonVersion1dot0dot0;
		assert: response contents equals: self dataStreamsSnapshotAsJSON
]

{ #category : #tests }
DataRESTfulWebServiceTest >> testGettingDataStreamWithWrongIdentifierGivesNotFound [

	self
		should: [ interface
				getStreamsBasedOn: (self requestToGetDataStreamIdentifiedBy: 1)
				within: self httpRequestContext ]
		raise: HTTPClientError
		withExceptionDo: [ :signal | 
			self
				assert: signal messageText
					equals: 'Data stream with that identifier not found';
				assert: signal code equals: 404 ]
]

{ #category : #tests }
DataRESTfulWebServiceTest >> testRoutesConfiguration [

	| teapot |

	teapot := Teapot on.

	(ReflectiveRoutesConfigurator appliedTo: teapot) addRoutesOf: interface.

	self assert: teapot routes size equals: 6
]

{ #category : #'accessing - media types' }
DataRESTfulWebServiceTest >> textPlain [

	^ 'text/plain;charset=utf-8' asZnMimeType
]

{ #category : #'accessing - requests' }
DataRESTfulWebServiceTest >> updateTemperatureAndPressureDataStreamsMalformattedRequest [

	^ (ZnRequest post: 'http://COSMOS_URL/v1/data-streams')
		entity:
			(ZnEntity
				with:
					'[
			{
				"xxx" : "Temperature",
				"value" : 24
			},
			{
				"data_stream" : "Pressure",
				"value" : 89
			}
		]'
				type: self applicationJsonVersion1dot0dot0)
]
