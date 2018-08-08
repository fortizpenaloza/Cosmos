Class {
	#name : #DataAPITest,
	#superclass : #SystemBasedUserStoryTest,
	#instVars : [
		'interface'
	],
	#category : #'Cosmos-API-Data-Tests'
}

{ #category : #history }
DataAPITest class >> lastStoredRun [
	^ ((Dictionary new) add: (#timeStamp->(DateAndTime basicNew instVarAt: 1 put: 6510; instVarAt: 2 put: (Duration seconds: -10800 nanoSeconds: 0); instVarAt: 3 put: 2458339; instVarAt: 4 put: 645031000; yourself)); add: (#passed->((Set new) add: #testDataPointBulkRegistration; add: #testDataPointBulkRegistrationFailsWithMalformattedRequest; yourself)); add: (#failures->((Set new))); add: (#errors->((Set new) add: #testDataStreamRegistration; add: #testQueryingDataStreamsSnapshot; add: #testDataStreamRegistrationFailsWithMalformattedRequest; add: #testQueryingStreamByName; add: #testDataStreamRegistrationFailsIfAlreadyExists; add: #testQueryingStreamByNameGivesNotFouldIfNotExists; yourself)); yourself)
]

{ #category : #accessing }
DataAPITest >> dataPointCollectionMimeTypeVersion1dot0dot0 [

	^ ZnMimeType fromString: 'application/vnd.cosmos.data-point+json; version=1.0.0'
]

{ #category : #'expected results' }
DataAPITest >> dataStreamsSnapshotAsJSON [

	^ '[
	{
		"name" : "Temperature",
		"current-value" : 16,
		"last-update" : "2014-10-01T12:00:00<1p>"
	},
	{
		"name" : "Pressure",
		"current-value" : 1016,
		"last-update" : "2014-10-01T12:00:00<1p>"
	},
	{
		"name" : "Humidity",
		"current-value" : 72,
		"last-update" : "2014-10-01T12:00:00<1p>"
	}
]' expandMacrosWith: TimeZones local offset
]

{ #category : #tests }
DataAPITest >> getDataStreamHttpRequest: uri [

	^ TeaRequest
		fromZnRequest:
			((ZnRequest get: uri)
				setAccept:
					(ZnMimeType
						fromString: 'application/vnd.cosmos.data-stream+json; version=1.0.0'))
]

{ #category : #accessing }
DataAPITest >> getDataStreamSnapshotsRequest [

	^ (ZnRequest get: 'http://COSMOS_URL/v1/data-streams')
		setAccept:
			(ZnMimeType
				fromString: 'application/vnd.cosmos.data-stream-snapshot+json; version=1.0.0')
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

	super setUp.

	interface := (DataAPIInstaller toInstallOn: Teapot on workingWith: rootSystem) install.

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

	^ '{
	"name" : "Temperature",
	"current-value" : 16,
	"last-update" : "2014-10-01T12:00:00<1p>",
	"data-points" : [
		{
			"timestamp" : "2014-10-01T12:00:00<1p>",
			"value" : 16
		},
		{
			"timestamp" : "2014-10-01T12:00:00<1p>",
			"value" : 15.5
		}
	]
}' expandMacrosWith: TimeZones local offset
]

{ #category : #accessing }
DataAPITest >> temperatureStream [

	^ self dataManagementSystem
		streamNamed: 'Temperature'
		ifFound: [ :dataStream | dataStream ]
		ifNone: [ "do nothing" ]
]

{ #category : #tests }
DataAPITest >> testDataPointBulkRegistration [

	| response temperature pressure |

	temperature := self temperatureStream.
	pressure := self pressureStream.

	self deny: temperature currentValue = 24.
	self deny: pressure currentValue = 89.

	response := interface
		registerBulkPointsBasedOn: self updateTemperatureAndPressureDataStreamsHttpRequest.

	self assert: response code equals: 201.

	self assert: temperature currentValue = 24.
	self assert: pressure currentValue = 89
]

{ #category : #tests }
DataAPITest >> testDataPointBulkRegistrationFailsWithMalformattedRequest [

	self
		should:
			[ interface registerBulkPointsBasedOn: self updateTemperatureAndPressureDataStreamsMalformattedRequest ]
		raise: HTTPClientError
		withDescription: '{"error":{"code":400,"message":"Expected key data-stream was not found"}'
]

{ #category : #tests }
DataAPITest >> testDataStreamRegistration [

	self dataManagementSystem
		streamNamed: 'pH'
		ifFound: [ :dataStream | self fail ]
		ifNone: [ "do nothing" ].

	interface
		registerStreamBasedOn:
			((ZnRequest post: 'http://COSMOS_URL/v1/data-streams')
				entity:
					(ZnEntity
						with: '{"name": "pH"}'
						type: (ZnMimeType fromString: 'application/vnd.cosmos.data-stream+json; version=1.0.0'))).

	self dataManagementSystem
		streamNamed: 'pH'
		ifFound: [ :dataStream | 
			self
				assert: dataStream name equals: 'pH';
				assert: dataStream creationDateTime equals: self timeSystem dateTime;
				assert: dataStream dataPoints isEmpty ]
		ifNone: [ self fail ]
]

{ #category : #tests }
DataAPITest >> testDataStreamRegistrationFailsIfAlreadyExists [

	self
		should: [ interface
				registerStreamBasedOn:
					((ZnRequest post: 'http://COSMOS_URL/v1/data-streams')
						entity:
							(ZnEntity
								with: '{"name": "Temperature"}'
								type: (ZnMimeType fromString: 'application/vnd.cosmos.data-stream+json; version=1.0.0'))) ]
		raise: HTTPClientError
		withDescription: 'A data stream with that name already exists in system'
]

{ #category : #tests }
DataAPITest >> testDataStreamRegistrationFailsWithMalformattedRequest [

	self
		should: [ interface
				registerStreamBasedOn:
					((ZnRequest post: 'http://COSMOS_URL/v1/data-streams')
						entity:
							(ZnEntity
								with: '{"xxx": "Temperature"}'
								type: (ZnMimeType fromString: 'application/vnd.cosmos.data-stream+json; version=1.0.0'))) ]
		raise: HTTPClientError
		withDescription: 'key #name not found in Dictionary'
]

{ #category : #tests }
DataAPITest >> testQueryingDataStreamsSnapshot [

	| response |

	response := interface
		streamsSnapshotsBasedOn: self getDataStreamSnapshotsRequest.

	self
		assert: response code equals: 200;
		assert: response contents equals: self dataStreamsSnapshotAsJSON
]

{ #category : #tests }
DataAPITest >> testQueryingStreamByName [

	| response |

	response := interface
		streamBasedOn: (self getDataStreamHttpRequest: 'http://COSMOS_URL/v1/data-streams?name=Temperature').

	self
		assert: response code equals: 200;
		assert: response contents equals: self temperatureDataStreamAsJSON
]

{ #category : #tests }
DataAPITest >> testQueryingStreamByNameGivesNotFouldIfNotExists [

	self
		should: [ interface
				streamBasedOn:
					(self
						getDataStreamHttpRequest: 'http://COSMOS_URL/v1/data-streams?name=pH') ]
		raise: HTTPClientError
		withDescription: 'Data stream with that name not found'
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
