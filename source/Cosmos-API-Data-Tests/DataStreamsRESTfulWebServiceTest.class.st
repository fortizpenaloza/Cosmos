Class {
	#name : #DataStreamsRESTfulWebServiceTest,
	#superclass : #SystemBasedUserStoryTest,
	#instVars : [
		'identifierSequence',
		'webService'
	],
	#category : #'Cosmos-API-Data-Tests'
}

{ #category : #'private - media types' }
DataStreamsRESTfulWebServiceTest >> applicationJsonVersion1dot0dot0 [

	^ 'application/json;version=1.0.0' asZnMimeType
]

{ #category : #'private - expected results' }
DataStreamsRESTfulWebServiceTest >> dataStreamsAsJSON [

	^ '[{"name":"Temperature","current_value":16.5,"last_update":"<1s>","metadata":[{"identifier":"<2p>"},{"registration_timestamp":"<1s>"}]},{"name":"Pressure","current_value":1016,"last_update":"<1s>","metadata":[{"identifier":"<3p>"},{"registration_timestamp":"<1s>"}]},{"name":"Humidity","current_value":"N/A","last_update":"N/A","metadata":[{"identifier":"<4p>"},{"registration_timestamp":"<1s>"}]}]'
		expandMacrosWith: self dateTimeFormattedAsISO8601
		with: self temperatureStreamIdentifier
		with: identifierSequence second
		with: identifierSequence third
]

{ #category : #'private - accessing' }
DataStreamsRESTfulWebServiceTest >> dateTimeFormattedAsISO8601 [

	^ ISO8601DateTimeFormatter usingExtendedFormat
		format: self systemDateTime
]

{ #category : #'private - accessing' }
DataStreamsRESTfulWebServiceTest >> httpRequestContext [

	^ HttpRequestContext new
]

{ #category : #'private - accessing' }
DataStreamsRESTfulWebServiceTest >> identifierProvider [

	^ SequentialIdentifierProvider providing: identifierSequence 
]

{ #category : #'private - requests' }
DataStreamsRESTfulWebServiceTest >> requestToCreateDataStreamFrom: aReprensentation [

	^ self
		requestToCreateDataStreamFrom: aReprensentation
		encodedAs: self applicationJsonVersion1dot0dot0
]

{ #category : #'private - requests' }
DataStreamsRESTfulWebServiceTest >> requestToCreateDataStreamFrom: aRepresentation encodedAs: aMediaType [

	^ (ZnRequest post: 'http://COSMOS_URL/data-streams')
		entity: (ZnEntity with: aRepresentation type: aMediaType)
]

{ #category : #'private - requests' }
DataStreamsRESTfulWebServiceTest >> requestToDeleteTemperatureStreamIdentifiedBy: anIdentifier [

	^ TeaRequest
		fromZnRequest: (ZnRequest delete: 'http://COSMOS_URL/data-streams')
		pathParams: {(#identifier -> anIdentifier)} asDictionary
]

{ #category : #'private - requests' }
DataStreamsRESTfulWebServiceTest >> requestToGetDataPointsOfDataStreamIdentifiedBy: anIdentifier [

	^ TeaRequest
		fromZnRequest:
			((ZnRequest get: 'http://COSMOS_URL/data-streams/' , anIdentifier asString , '/data-points')
				setAccept: self applicationJsonVersion1dot0dot0)
		pathParams: {(#identifier -> anIdentifier)} asDictionary
]

{ #category : #'private - requests' }
DataStreamsRESTfulWebServiceTest >> requestToGetDataStreamIdentifiedBy: anIdentifier [

	^ TeaRequest
		fromZnRequest:
			((ZnRequest get: 'http://COSMOS_URL/data-streams/')
				setAccept: self applicationJsonVersion1dot0dot0)
		pathParams: {(#identifier -> anIdentifier)} asDictionary
]

{ #category : #'private - requests' }
DataStreamsRESTfulWebServiceTest >> requestToGetDataStreams [

	^ TeaRequest
		fromZnRequest:
			((ZnRequest get: 'http://COSMOS_URL/data-streams')
				setAccept: self applicationJsonVersion1dot0dot0)
]

{ #category : #running }
DataStreamsRESTfulWebServiceTest >> setUp [

	identifierSequence := {UUID new.
	UUID new.
	UUID new.
	UUID new}.

	super setUp.

	webService := DataStreamsRESTfulWebService workingWith: rootSystem.
	 		
	(SensorsSampleAddOn on: rootSystem) install
]

{ #category : #running }
DataStreamsRESTfulWebServiceTest >> setUpRequirements [

	super
		setUpRequirements;
		requireDataManagementSystem.
 
]

{ #category : #'private - expected results' }
DataStreamsRESTfulWebServiceTest >> temperatureDataStreamAsJSON [

	^ '{"name":"Temperature","current_value":16.5,"last_update":"<1s>","metadata":[{"identifier":"<2p>"},{"registration_timestamp":"<1s>"}]}'
		expandMacrosWith: self dateTimeFormattedAsISO8601
		with: self temperatureStreamIdentifier
]

{ #category : #'private - accessing' }
DataStreamsRESTfulWebServiceTest >> temperatureStreamIdentifier [

	^ identifierSequence first
]

{ #category : #tests }
DataStreamsRESTfulWebServiceTest >> testCreateDataStream [

	| response |

	self dataManagementSystem
		streamNamed: 'pH'
		ifFound: [ :dataStream | self fail ]
		ifNone: [ "do nothing" ].

	response := webService
		createStreamBasedOn: (self requestToCreateDataStreamFrom: '{"name":"pH"}')
		within: self httpRequestContext.

	self
		assert: response isSuccess;
		assert: response code equals: 201;
		assert: response location
			equals: '/data-streams/' , identifierSequence last asString;
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
DataStreamsRESTfulWebServiceTest >> testCreatingDataStreamFailsFromMalformattedRequest [

	self
		should: [ webService
				createStreamBasedOn: (self requestToCreateDataStreamFrom: '{"XXX":"Temperature"}')
				within: self httpRequestContext ]
		raise: HTTPClientError
		withExceptionDo: [ :signal | 
			self
				assert: signal messageText equals: 'Expected key name was not found';
				assert: signal code equals: 400 ]
]

{ #category : #tests }
DataStreamsRESTfulWebServiceTest >> testCreatingDataStreamFailsFromUnsuportedMediaType [

	self
		should: [ webService
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
DataStreamsRESTfulWebServiceTest >> testCreatingDataStreamFailsIfAlreadyExists [

	self
		should: [ webService
				createStreamBasedOn: (self requestToCreateDataStreamFrom: '{"name":"Temperature"}')
				within: self httpRequestContext ]
		raise: HTTPClientError
		withExceptionDo: [ :signal | 
			self
				assert: signal messageText equals: 'A data stream with that name already exists in system';
				assert: signal code equals: 409 ]
]

{ #category : #tests }
DataStreamsRESTfulWebServiceTest >> testDeleteDataStream [

	| response |

	self dataManagementSystem
		streamNamed: 'Temperature'
		ifFound: [ :dataStream | "do nothing" ]
		ifNone: [ self fail ].

	response := webService
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
DataStreamsRESTfulWebServiceTest >> testDeletingDataStreamWithWrongIdentifierGivesNotFound [

	self
		should: [ webService
				deleteStreamBasedOn: (self requestToDeleteTemperatureStreamIdentifiedBy: 1)
				within: self httpRequestContext ]
		raise: HTTPClientError
		withExceptionDo: [ :signal | 
			self
				assert: signal messageText equals: 'Data stream with that identifier not found';
				assert: signal code equals: 404 ]
]

{ #category : #tests }
DataStreamsRESTfulWebServiceTest >> testGetDataStream [

	| response |

	response := webService
		getStreamBasedOn: (self requestToGetDataStreamIdentifiedBy: self temperatureStreamIdentifier)
		within: self httpRequestContext.

	self
		assert: response isSuccess;
		assert: response code equals: 200;
		assert: response contentType equals: self applicationJsonVersion1dot0dot0;
		assert: response contents equals: self temperatureDataStreamAsJSON
]

{ #category : #tests }
DataStreamsRESTfulWebServiceTest >> testGetDataStreamDataPoints [

	| response |

	response := webService
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
DataStreamsRESTfulWebServiceTest >> testGetDataStreams [

	| response |

	response := webService
		getStreamsBasedOn: self requestToGetDataStreams
		within: self httpRequestContext.

	self
		assert: response isSuccess;
		assert: response code equals: 200;
		assert: response contentType equals: self applicationJsonVersion1dot0dot0;
		assert: response contents equals: self dataStreamsAsJSON
]

{ #category : #tests }
DataStreamsRESTfulWebServiceTest >> testGettingDataStreamWithWrongIdentifierGivesNotFound [

	self
		should: [ webService
				getStreamBasedOn: (self requestToGetDataStreamIdentifiedBy: 1)
				within: self httpRequestContext ]
		raise: HTTPClientError
		withExceptionDo: [ :signal | 
			self
				assert: signal messageText
					equals: 'Data stream with that identifier not found';
				assert: signal code equals: 404 ]
]

{ #category : #tests }
DataStreamsRESTfulWebServiceTest >> testRoutesConfiguration [

	| teapot |

	teapot := Teapot on.

	(ReflectiveRoutesConfigurator appliedTo: teapot) addRoutesOf: webService.

	self assert: teapot routes size equals: 5
]

{ #category : #'private - media types' }
DataStreamsRESTfulWebServiceTest >> textPlain [

	^ 'text/plain;charset=utf-8' asZnMimeType
]
