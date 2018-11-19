Class {
	#name : #DataStreamsRESTfulControllerTest,
	#superclass : #SystemBasedUserStoryTest,
	#instVars : [
		'identifierSequence',
		'resourceController'
	],
	#category : #'Cosmos-API-Data-Tests'
}

{ #category : #'private - media types' }
DataStreamsRESTfulControllerTest >> applicationJsonVersion1dot0dot0MediaType [

	^ 'application/json;version=1.0.0' asMediaType
]

{ #category : #'private - accessing' }
DataStreamsRESTfulControllerTest >> baseUrl [

	^ 'https://tests.cosmos.com' asZnUrl
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
DataStreamsRESTfulControllerTest >> requestToCreateDataStreamFrom: aRepresentation [

	^ self
		requestToPOST: aRepresentation
		as: self applicationJsonVersion1dot0dot0MediaType
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

	^ TeaRequest
		fromZnRequest:
			((ZnRequest get: (self urlForResourceIdentifiedBy: anIdentifier))
				setAccept: aMediaType;
				yourself)
		pathParams: {(#identifier -> anIdentifier)} asDictionary
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
DataStreamsRESTfulControllerTest >> requestToGetDataStreams [

	^ TeaRequest
		fromZnRequest:
			((ZnRequest get: 'http://COSMOS_URL/data-streams')
				setAccept: self applicationJsonVersion1dot0dot0MediaType;
				yourself)
]

{ #category : #'private - requests' }
DataStreamsRESTfulControllerTest >> requestToPOST: aRepresentation as: aMediaType [

	^ TeaRequest
		fromZnRequest:
			((ZnRequest post: self resourceUrl)
				entity: (ZnEntity with: aRepresentation type: aMediaType);
				yourself)
]

{ #category : #'private - accessing' }
DataStreamsRESTfulControllerTest >> resourceUrl [

	^ self baseUrl / resourceController specification endpoint
]

{ #category : #running }
DataStreamsRESTfulControllerTest >> setUp [

	identifierSequence := {
	(UUID fromString: 'ab203809-4537-0d00-96a8-67bd07fa2cfc').
	(UUID fromString: 'c3e53a0a-4537-0d00-96a9-ad5f07fa2cfc').
	(UUID fromString: '6fbb430b-4537-0d00-96aa-582b07fa2cfc').
	(UUID fromString: '62ede40b-4537-0d00-96ab-a32d07fa2cfc')}.

	super setUp.
	
	resourceController := DataStreamsRESTfulController workingWith: rootSystem.
	resourceController serverUrl: self baseUrl asZnUrl.
	
	(SensorsSampleAddOn on: rootSystem) install
]

{ #category : #running }
DataStreamsRESTfulControllerTest >> setUpRequirements [

	super
		setUpRequirements;
		requireDataManagementSystem.
 
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

	^ identifierSequence first
]

{ #category : #tests }
DataStreamsRESTfulControllerTest >> testCreateDataStream [

	| response |

	response := resourceController
		createStreamBasedOn: (self requestToCreateDataStreamFrom: '{"name":"pH"}')
		within: self httpRequestContext.

	self
		assert: response isSuccess;
		assert: response code equals: 201;
		assert: response location equals: (self resourceUrl / identifierSequence last asString) asString;
		assert: response contentType equals: self textPlainMediaType.

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
				createStreamBasedOn: (self requestToPOST: '{"name":"Temperature"}' as: self unsupportedMediaType)
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

	self
		assert:
			(self dataManagementSystem
				streamNamed: 'Temperature'
				ifFound: [ :dataStream | true ]
				ifNone: [ self fail ]).
				
	response := resourceController
		deleteStreamBasedOn: (self requestToDeleteStreamIdentifiedBy: self temperatureStreamIdentifier)
		within: self httpRequestContext.

	self assert: (self dataManagementSystem
		streamNamed: 'Temperature'
		ifFound: [ :dataStream | self fail ]
		ifNone: [ true ]).

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
			(self
				requestToGetDataStreamIdentifiedBy: self temperatureStreamIdentifier
				accepting: self applicationJsonVersion1dot0dot0MediaType)
		within: self httpRequestContext.

	self
		assert: response isSuccess;
		assert: response status equals: 200;
		assert: response contentType
			equals: self applicationJsonVersion1dot0dot0MediaType;
		assert: response entityTag equals: '"2e7eccc8701bd15953f68d2dce8b8fa2d68575ee"' asETag;
		withJsonFromContentsIn: response contents
 		do: [ :json | 
			self
				assert: json name equals: 'Temperature';
				assert: json current_value equals: 16.5;
				assert: json last_update equals: self dateTimeFormattedAsISO8601;
				assert: json metadata size equals: 2 ]
]

{ #category : #tests }
DataStreamsRESTfulControllerTest >> testGetDataStreamDataPoints [

	| response |

	response := resourceController
		getPointsBasedOn:
			(self
				requestToGetDataPointsOfDataStreamIdentifiedBy: self temperatureStreamIdentifier
				accepting: self applicationJsonVersion1dot0dot0MediaType)
		within: self httpRequestContext.

	self
		assert: response isSuccess;
		assert: response status equals: 200;
		assert: response contentType equals: self applicationJsonVersion1dot0dot0MediaType;
		withJsonFromContentsIn: response
			do: [ :json | 
			self assert: json size equals: 3.
			self
				assert: json first timestamp equals: self dateTimeFormattedAsISO8601;
				assert: json first value equals: 16.5 ]
]

{ #category : #tests }
DataStreamsRESTfulControllerTest >> testGetDataStreams [

	| response |

	response := resourceController
		getStreamsBasedOn: self requestToGetDataStreams
		within: self httpRequestContext.

	self
		assert: response isSuccess;
		assert: response status equals: 200;
		assert: response contentType equals: self applicationJsonVersion1dot0dot0MediaType;
		assert: response contents equals: self dataStreamsAsJSON
]

{ #category : #tests }
DataStreamsRESTfulControllerTest >> testGetNotModifiedWhenValidETag [

	| response |

	response := resourceController
		getStreamBasedOn:
			(self
				requestToGetDataStreamIdentifiedBy: self temperatureStreamIdentifier
				accepting: self applicationJsonVersion1dot0dot0MediaType)
		within: self httpRequestContext.

	self
		assert: response isSuccess;
		assert: response status equals: 200;
		assert: response entityTag equals: '"2e7eccc8701bd15953f68d2dce8b8fa2d68575ee"' asETag.
		
		response := resourceController
		getStreamBasedOn:
			(self
				requestToGetDataStreamIdentifiedBy: self temperatureStreamIdentifier
				accepting: self applicationJsonVersion1dot0dot0MediaType
				conditionalTo: '"2e7eccc8701bd15953f68d2dce8b8fa2d68575ee"' asETag)
		within: self httpRequestContext.
		
	self
		assert: response status equals: 304;
		assert: response entityTag equals: '"2e7eccc8701bd15953f68d2dce8b8fa2d68575ee"' asETag
]

{ #category : #tests }
DataStreamsRESTfulControllerTest >> testGettingDataStreamWithWrongIdentifierGivesNotFound [

	self
		should: [ resourceController
				getStreamBasedOn:
					(self
						requestToGetDataStreamIdentifiedBy: 1
						accepting: self applicationJsonVersion1dot0dot0MediaType)
				within: self httpRequestContext ]
		raise: HTTPClientError
		withExceptionDo: [ :signal | 
			self
				assert: signal messageText equals: 'Data stream with that identifier not found';
				assert: signal code equals: 404 ]
]

{ #category : #'private - media types' }
DataStreamsRESTfulControllerTest >> textPlainMediaType [

	^ 'text/plain;charset=utf-8' asMediaType
]

{ #category : #'private - accessing' }
DataStreamsRESTfulControllerTest >> unsupportedMediaType [
	
	^ self textPlainMediaType 
]

{ #category : #'private - accessing' }
DataStreamsRESTfulControllerTest >> urlForResourceIdentifiedBy: anIdentifier [

	^ self resourceUrl / anIdentifier printString asZnUrl
]
