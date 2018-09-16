Class {
	#name : #DataAPITest,
	#superclass : #SystemBasedUserStoryTest,
	#instVars : [
		'interface',
		'identifierSequence'
	],
	#category : #'Cosmos-API-Data-Tests'
}

{ #category : #'accessing - media types' }
DataAPITest >> applicationJsonVersion1dot0dot0 [

	^ ZnMimeType fromString: 'application/json;version=1.0.0'
]

{ #category : #'accessing - media types' }
DataAPITest >> dataPointCollectionMimeTypeVersion1dot0dot0 [

	^ ZnMimeType fromString: 'application/vnd.cosmos.data-point+json; version=1.0.0'
]

{ #category : #'expected results' }
DataAPITest >> dataStreamsSnapshotAsJSON [

	^ '[{"name":"Temperature","current-value":16.5,"last-update":"<1s>","metadata":[{"identifier":"<2s>"},{"registration_timestamp":"<1s>"}]},{"name":"Pressure","current-value":1016,"last-update":"<1s>","metadata":[{"identifier":"<3s>"},{"registration_timestamp":"<1s>"}]},{"name":"Humidity","current-value":"N/A","last-update":"N/A","metadata":[{"identifier":"<4s>"},{"registration_timestamp":"<1s>"}]}]'
		expandMacrosWith: self dateTimeFormattedAsISO8601
		with: self temperatureStreamIdentifier asString36
		with: identifierSequence second asString36
		with: identifierSequence third asString36
]

{ #category : #accessing }
DataAPITest >> dateTimeFormattedAsISO8601 [

	^ ISO8601DateTimeFormatter usingExtendedFormat
		format: self systemDateTime
]

{ #category : #'accessing - requests' }
DataAPITest >> deleteInexistantStreamHttpRequest [

	^ TeaRequest
		fromZnRequest:
			(ZnRequest
				delete: 'http://COSMOS_URL/data-streams' )
		pathParams: {(#identifier -> 'wrong_identifier')} asDictionary
]

{ #category : #'accessing - requests' }
DataAPITest >> deleteTemperatureStreamHttpRequest [

	^ TeaRequest
		fromZnRequest: (ZnRequest delete: 'http://COSMOS_URL/data-streams')
		pathParams: {(#identifier -> self temperatureStreamIdentifier)} asDictionary
]

{ #category : #'accessing - requests' }
DataAPITest >> getDataStreamHttpRequestTo: uri with: params [

	^ TeaRequest
		fromZnRequest:
			((ZnRequest get: uri)
				setAccept:
					(self applicationJsonVersion1dot0dot0))
		pathParams: params
]

{ #category : #'accessing - requests' }
DataAPITest >> getDataStreamSnapshotsHttpRequest [

	^ TeaRequest
		fromZnRequest:
			((ZnRequest get: 'http://COSMOS_URL/data-streams')
				setAccept: self applicationJsonVersion1dot0dot0)
]

{ #category : #'accessing - requests' }
DataAPITest >> getDataStreamWithWrongIdentifierHttpRequest [

	^ self
		getDataStreamHttpRequestTo: 'http://COSMOS_URL/data-streams'
		with: {(#identifier -> 'wrong')} asDictionary 
]

{ #category : #'accessing - requests' }
DataAPITest >> getTemperatureStreamDataPointsHttpRequest [

	^ TeaRequest
		fromZnRequest:
			((ZnRequest
				get:
					'http://COSMOS_URL/data-streams/'
						, self temperatureStreamIdentifier asString36 , '/data-points')
				setAccept:
					(ZnMimeType
						fromString: 'application/vnd.cosmos.data-points+json; version=1.0.0'))
		pathParams: {(#identifier -> self temperatureStreamIdentifier)} asDictionary
]

{ #category : #'accessing - requests' }
DataAPITest >> getTemperatureStreamHttpRequest [

	^ self
		getDataStreamHttpRequestTo: 'http://COSMOS_URL/data-streams/'
		with: {(#identifier -> self temperatureStreamIdentifier)} asDictionary
]

{ #category : #accessing }
DataAPITest >> identifierProvider [

	^ SequentialIdentifierProvider providing: identifierSequence 
]

{ #category : #accessing }
DataAPITest >> pressureStream [

	^ self dataManagementSystem
		streamNamed: 'Pressure'
		ifFound: [ :dataStream | dataStream ]
		ifNone: [ "do nothing" ]
]

{ #category : #running }
DataAPITest >> setUp [

	identifierSequence := {UUID new.
	UUID new.
	UUID new.
	UUID new}.

	super setUp.

	interface := DataWebService workingWith: rootSystem.
	 		
	(SensorsSampleAddOn on: rootSystem) install
]

{ #category : #running }
DataAPITest >> setUpRequirements [

	super
		setUpRequirements;
		requireDataManagementSystem.
 
]

{ #category : #'expected results' }
DataAPITest >> temperatureDataStreamAsJSON [

	^ '{"name":"Temperature","current-value":16.5,"last-update":"<1s>","metadata":[{"identifier":"<2s>"},{"registration_timestamp":"<1s>"}]}'
		expandMacrosWith: self dateTimeFormattedAsISO8601
		with: self temperatureStreamIdentifier asString36
]

{ #category : #accessing }
DataAPITest >> temperatureStream [

	^ self dataManagementSystem
		streamNamed: 'Temperature'
		ifFound: [ :dataStream | dataStream ]
		ifNone: [ "do nothing" ]
]

{ #category : #accessing }
DataAPITest >> temperatureStreamIdentifier [

	^ identifierSequence first
]

{ #category : #tests }
DataAPITest >> testCreatingDataStream [

	| response |

	self dataManagementSystem
		streamNamed: 'pH'
		ifFound: [ :dataStream | self fail ]
		ifNone: [ "do nothing" ].

	response := interface
		createStreamBasedOn:
			((ZnRequest post: 'http://COSMOS_URL/data-streams')
				entity:
					(ZnEntity
						with: '{"name":"pH"}'
						type: self applicationJsonVersion1dot0dot0))
		within: self httpRequestContext.

	self
		assert: response code equals: 201;
		assert: response location
			equals: '/localhost/' , identifierSequence last asString36;
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
DataAPITest >> testCreatingDataStreamFailsIfAlreadyExists [

	self
		should: [ interface
				createStreamBasedOn:
					((ZnRequest post: 'http://COSMOS_URL/v1/data-streams')
						entity:
							(ZnEntity
								with: '{"name":"Temperature"}'
								type: self applicationJsonVersion1dot0dot0))
				within: self httpRequestContext ]
		raise: HTTPClientError
		withDescription: 'A data stream with that name already exists in system'
]

{ #category : #tests }
DataAPITest >> testCreatingDataStreamFailsWithWrongMediaType [

	self
		should: [ interface
				createStreamBasedOn:
					((ZnRequest post: 'http://COSMOS_URL/v1/data-streams')
						entity:
							(ZnEntity
								with: '{"name":"Temperature"}'
								type: self applicationJsonVersion1dot0dot0))
				within: self httpRequestContext ]
		raise: HTTPClientError
		withDescription: 'A data stream with that name already exists in system'
]

{ #category : #tests }
DataAPITest >> testCreatingStreamFailsWithMalformattedRequest [

	self
		should: [ interface
				createStreamBasedOn:
					((ZnRequest post: 'http://COSMOS_URL/v1/data-streams')
						entity:
							(ZnEntity
								with: '{"name":"pH"}'
								type:
									(ZnMimeType
										fromString: 'application/vnd.cosmos.data-stream+json; version=1.0.0')))
				within: self httpRequestContext ]
		raise: HTTPClientError
		withDescription: 'Decoder not found for given media type'
]

{ #category : #tests }
DataAPITest >> testDataPointBulkRegistration [

	| response temperature pressure |

	temperature := self temperatureStream.
	pressure := self pressureStream.

	self deny: temperature currentValue = 24.
	self deny: pressure currentValue = 89.

	response := interface
		createBulkPointsBasedOn: self updateTemperatureAndPressureDataStreamsHttpRequest
		within: self httpRequestContext.

	self assert: response code equals: 201.

	self assert: temperature currentValue = 24.
	self assert: pressure currentValue = 89
]

{ #category : #tests }
DataAPITest >> testDataPointBulkRegistrationFailsWithMalformattedRequest [

	self
		should: [ interface
				createBulkPointsBasedOn: self updateTemperatureAndPressureDataStreamsMalformattedRequest
				within: self httpRequestContext ]
		raise: HTTPClientError
		withDescription: 'Expected key data-stream was not found'
]

{ #category : #tests }
DataAPITest >> testDeletingDataStream [

	| response |

	self dataManagementSystem
		streamNamed: 'Temperature'
		ifFound: [ :dataStream | "do nothing" ]
		ifNone: [ self fail ].

	response := interface
		deleteStreamBasedOn: self deleteTemperatureStreamHttpRequest
		within: self httpRequestContext.

	self dataManagementSystem
		streamNamed: 'Temperature'
		ifFound: [ :dataStream | self fail ]
		ifNone: [ "do nothing" ].

	self assert: response code equals: 204
]

{ #category : #tests }
DataAPITest >> testDeletingDataStreamWithWrongIdentifierGivesNotFound [

	self
		should: [ interface
				deleteStreamBasedOn: self deleteInexistantStreamHttpRequest
				within: self httpRequestContext ]
		raise: HTTPClientError
		withExceptionDo: [ :signal | 
			self
				assert: signal messageText
					equals: 'Data stream with that identifier not found';
				assert: signal code equals: 404 ]
]

{ #category : #tests }
DataAPITest >> testGettingDataPoints [

	| response |

	response := interface
		getPointsBasedOn: self getTemperatureStreamDataPointsHttpRequest
		within: self httpRequestContext.

	self
		assert: response code equals: 200;
		assert: response contents
			equals:
			('[
	{
		"timestamp" : "<1s>",
		"value" : 16.5
	},
	{
		"timestamp" : "<1s>",
		"value" : 16
	},
	{
		"timestamp" : "<1s>",
		"value" : 15.5
	}
]' expandMacrosWith: self dateTimeFormattedAsISO8601)
]

{ #category : #tests }
DataAPITest >> testGettingDataStreamByIdentifier [

	| response |

	response := interface
		getStreamsBasedOn: self getTemperatureStreamHttpRequest
		within: self httpRequestContext.

	self
		assert: response code equals: 200;
		assert: response contents equals: self temperatureDataStreamAsJSON
]

{ #category : #tests }
DataAPITest >> testGettingDataStreamWithWrongIdentifierGivesNotFound [

	self
		should: [ interface
				getStreamsBasedOn: self getDataStreamWithWrongIdentifierHttpRequest
				within: self httpRequestContext ]
		raise: HTTPClientError
		withExceptionDo: [ :signal | 
			self
				assert: signal messageText
					equals: 'Data stream with that identifier not found';
				assert: signal code equals: 404 ]
]

{ #category : #tests }
DataAPITest >> testGettingDataStreams [

	| response |

	response := interface
		getStreamsBasedOn: self getDataStreamSnapshotsHttpRequest
		within: self httpRequestContext.

	self
		assert: response code equals: 200;
		assert: response contents equals: self dataStreamsSnapshotAsJSON
]

{ #category : #accessing }
DataAPITest >> updateTemperatureAndPressureDataStreamsHttpRequest [

	^ (ZnRequest post: 'http://COSMOS_URL/v1/data-streams')
		entity:
			(ZnEntity
				with:
					'[
			{
				"data-stream" : "Temperature",
				"value" : 24
			},
			{
				"data-stream" : "Pressure",
				"value" : 89
			}
		]'
				type: self dataPointCollectionMimeTypeVersion1dot0dot0)
]

{ #category : #accessing }
DataAPITest >> updateTemperatureAndPressureDataStreamsMalformattedRequest [

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
				"data-stream" : "Pressure",
				"value" : 89
			}
		]'
				type: self dataPointCollectionMimeTypeVersion1dot0dot0)
]
