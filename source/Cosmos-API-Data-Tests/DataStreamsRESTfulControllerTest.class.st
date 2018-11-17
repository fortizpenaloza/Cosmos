Class {
	#name : #DataStreamsRESTfulControllerTest,
	#superclass : #SystemBasedUserStoryTest,
	#instVars : [
		'identifierSequence',
		'webService'
	],
	#category : #'Cosmos-API-Data-Tests'
}

{ #category : #'private - media types' }
DataStreamsRESTfulControllerTest >> applicationJsonVersion1dot0dot0MediaType [

	^ 'application/json;version=1.0.0' asZnMimeType
]

{ #category : #'private - expected results' }
DataStreamsRESTfulControllerTest >> dataStreamsAsJSON [

	^ '[{"name":"Temperature","current_value":16.5,"last_update":"<1s>","metadata":[{"identifier":"<2p>"},{"registration_timestamp":"<1s>"}]},{"name":"Pressure","current_value":1016,"last_update":"<1s>","metadata":[{"identifier":"<3p>"},{"registration_timestamp":"<1s>"}]},{"name":"Humidity","current_value":"N/A","last_update":"N/A","metadata":[{"identifier":"<4p>"},{"registration_timestamp":"<1s>"}]}]'
		expandMacrosWith: self dateTimeFormattedAsISO8601
		with: self temperatureStreamIdentifier
		with: identifierSequence second
		with: identifierSequence third
]

{ #category : #'private - accessing' }
DataStreamsRESTfulControllerTest >> dateTimeFormattedAsISO8601 [

	^ ISO8601DateTimeFormatter usingExtendedFormat
		format: self systemDateTime
]

{ #category : #'private - accessing' }
DataStreamsRESTfulControllerTest >> httpRequestContext [

	^ HttpRequestContext new
]

{ #category : #'private - accessing' }
DataStreamsRESTfulControllerTest >> identifierProvider [

	^ SequentialIdentifierProvider providing: identifierSequence 
]

{ #category : #'private - requests' }
DataStreamsRESTfulControllerTest >> requestToCreateDataStreamFrom: aReprensentation [

	^ self
		requestToCreateDataStreamFrom: aReprensentation
		encodedAs: self applicationJsonVersion1dot0dot0MediaType
]

{ #category : #'private - requests' }
DataStreamsRESTfulControllerTest >> requestToCreateDataStreamFrom: aRepresentation encodedAs: aMediaType [

	^ (ZnRequest post: 'http://COSMOS_URL/data-streams')
		entity: (ZnEntity with: aRepresentation type: aMediaType)
]

{ #category : #'private - requests' }
DataStreamsRESTfulControllerTest >> requestToDeleteTemperatureStreamIdentifiedBy: anIdentifier [

	^ TeaRequest
		fromZnRequest: (ZnRequest delete: 'http://COSMOS_URL/data-streams')
		pathParams: {(#identifier -> anIdentifier)} asDictionary
]

{ #category : #'private - requests' }
DataStreamsRESTfulControllerTest >> requestToGetDataPointsOfDataStreamIdentifiedBy: anIdentifier [

	^ TeaRequest
		fromZnRequest:
			((ZnRequest get: 'http://COSMOS_URL/data-streams/' , anIdentifier asString , '/data-points')
				setAccept: self applicationJsonVersion1dot0dot0MediaType)
		pathParams: {(#identifier -> anIdentifier)} asDictionary
]

{ #category : #'private - requests' }
DataStreamsRESTfulControllerTest >> requestToGetDataStreamIdentifiedBy: anIdentifier [

	^ TeaRequest
		fromZnRequest:
			((ZnRequest get: 'http://COSMOS_URL/data-streams/')
				setAccept: self applicationJsonVersion1dot0dot0MediaType)
		pathParams: {(#identifier -> anIdentifier)} asDictionary
]

{ #category : #'private - requests' }
DataStreamsRESTfulControllerTest >> requestToGetDataStreams [

	^ TeaRequest
		fromZnRequest:
			((ZnRequest get: 'http://COSMOS_URL/data-streams')
				setAccept: self applicationJsonVersion1dot0dot0MediaType)
]

{ #category : #running }
DataStreamsRESTfulControllerTest >> setUp [

	identifierSequence := {UUID new.
	UUID new.
	UUID new.
	UUID new}.

	super setUp.

	webService := DataStreamsRESTfulController workingWith: rootSystem.
	 		
	(SensorsSampleAddOn on: rootSystem) install
]

{ #category : #running }
DataStreamsRESTfulControllerTest >> setUpRequirements [

	super
		setUpRequirements;
		requireDataManagementSystem.
 
]

{ #category : #'private - expected results' }
DataStreamsRESTfulControllerTest >> temperatureDataStreamAsJSON [

	^ '{"name":"Temperature","current_value":16.5,"last_update":"<1s>","metadata":[{"identifier":"<2p>"},{"registration_timestamp":"<1s>"}]}'
		expandMacrosWith: self dateTimeFormattedAsISO8601
		with: self temperatureStreamIdentifier
]

{ #category : #'private - accessing' }
DataStreamsRESTfulControllerTest >> temperatureStreamIdentifier [

	^ identifierSequence first
]

{ #category : #tests }
DataStreamsRESTfulControllerTest >> testCreateDataStream [

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
DataStreamsRESTfulControllerTest >> testCreatingDataStreamFailsFromMalformattedRequest [

	self
		should: [ webService
				createStreamBasedOn: (self requestToCreateDataStreamFrom: '{"XXX":"Temperature"}')
				within: self httpRequestContext ]
		raise: HTTPClientError
		withExceptionDo: [ :signal | 
			self
				assert: signal messageText equals: 'key #name not found in Dictionary';
				assert: signal code equals: 400 ]
]

{ #category : #tests }
DataStreamsRESTfulControllerTest >> testCreatingDataStreamFailsFromUnsuportedMediaType [

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
DataStreamsRESTfulControllerTest >> testCreatingDataStreamFailsIfAlreadyExists [

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
DataStreamsRESTfulControllerTest >> testDeleteDataStream [

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
DataStreamsRESTfulControllerTest >> testDeletingDataStreamWithWrongIdentifierGivesNotFound [

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
DataStreamsRESTfulControllerTest >> testGetDataStream [

	| response |

	response := webService
		getStreamBasedOn: (self requestToGetDataStreamIdentifiedBy: self temperatureStreamIdentifier)
		within: self httpRequestContext.

	self
		assert: response isSuccess;
		assert: response code equals: 200;
		assert: response contentType equals: self applicationJsonVersion1dot0dot0MediaType;
		assert: response contents equals: self temperatureDataStreamAsJSON
]

{ #category : #tests }
DataStreamsRESTfulControllerTest >> testGetDataStreamDataPoints [

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
DataStreamsRESTfulControllerTest >> testGetDataStreams [

	| response |

	response := webService
		getStreamsBasedOn: self requestToGetDataStreams
		within: self httpRequestContext.

	self
		assert: response isSuccess;
		assert: response code equals: 200;
		assert: response contentType equals: self applicationJsonVersion1dot0dot0MediaType;
		assert: response contents equals: self dataStreamsAsJSON
]

{ #category : #tests }
DataStreamsRESTfulControllerTest >> testGettingDataStreamWithWrongIdentifierGivesNotFound [

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

{ #category : #'private - media types' }
DataStreamsRESTfulControllerTest >> textPlain [

	^ 'text/plain;charset=utf-8' asZnMimeType
]
