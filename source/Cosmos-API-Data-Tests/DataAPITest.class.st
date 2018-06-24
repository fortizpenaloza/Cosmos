Class {
	#name : #DataAPITest,
	#superclass : #SystemBasedUserStoryTest,
	#category : #'Cosmos-API-Data-Tests'
}

{ #category : #'expected results' }
DataAPITest >> dataStreamsSnapshotAsJSON [

	^ '[
	{
		"name" : "Temperature",
		"current-value" : 16,
		"last-update" : "2015-09-06T12:00:00<1p>"
	},
	{
		"name" : "Pressure",
		"current-value" : 1016,
		"last-update" : "2015-09-06T12:00:00<1p>"
	},
	{
		"name" : "Humidity",
		"current-value" : 72,
		"last-update" : "2015-09-06T12:00:00<1p>"
	}
]' expandMacrosWith: TimeZones local offset
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
	"last-update" : "2015-09-06T12:00:00<1p>",
	"data-points" : [
		{
			"timestamp" : "2015-09-06T12:00:00<1p>",
			"value" : 16
		},
		{
			"timestamp" : "2015-09-06T12:00:00<1p>",
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

	| interface response temperature pressure |

	temperature := self temperatureStream.
	pressure := self pressureStream.

	self deny: temperature currentValue = 24.
	self deny: pressure currentValue = 89.

	interface := DataAPI workingWithin: rootSystem.
	response := interface registerBulkPointsFrom: self updateTemperatureAndPressureDataStreamsJSON.

	self assert: response code equals: 201.

	self assert: temperature currentValue = 24.
	self assert: pressure currentValue = 89
]

{ #category : #tests }
DataAPITest >> testDataPointBulkRegistrationFailsWithMalformattedRequest [

	| interface |

	interface := DataAPI workingWithin: rootSystem.

	self
		should: [ interface
				registerBulkPointsFrom:
					'[
			{
				"xxx" : "Temperature",
				"value" : 24
			},
			{
				"data-stream" : "Pressure",
				"value" : 89
			}
		]' ]
		raise: HTTPClientError
		withDescription: '{"error":{"code":400,"message":"Expected key data-stream was not found"}'
]

{ #category : #tests }
DataAPITest >> testDataStreamRegistration [

	| interface |

	self dataManagementSystem
		streamNamed: 'pH'
		ifFound: [ :dataStream | self fail ]
		ifNone: [ "do nothing" ].

	interface := DataAPI workingWithin: rootSystem.
	interface registerStreamFrom: '{"name": "pH"}'.

	self dataManagementSystem
		streamNamed: 'pH'
		ifFound: [ :dataStream | 
			self
				assert: dataStream name equals: 'pH';
				assert: dataStream creationDateTime
					equals: self timeSystem dateTime;
				assert: dataStream dataPoints isEmpty ]
		ifNone: [ self fail ]
]

{ #category : #tests }
DataAPITest >> testDataStreamRegistrationFailsIfAlreadyExists [

	| interface |

	interface := DataAPI workingWithin: rootSystem.

	self
		should: [ interface registerStreamFrom: '{"name": "Temperature"}' ]
		raise: HTTPClientError
		withDescription: 'A data stream with that name already exists in system'
]

{ #category : #tests }
DataAPITest >> testDataStreamRegistrationFailsWithMalformattedRequest [

	| interface |

	interface := DataAPI workingWithin: rootSystem.

	self
		should: [ interface registerStreamFrom: '{"xxx": "Temperature"}' ]
		raise: HTTPClientError
		withDescription: 'key #name not found in Dictionary'
]

{ #category : #tests }
DataAPITest >> testQueryingDataStreamsSnapshot [

	| interface response |

	interface := DataAPI workingWithin: rootSystem.
	response := interface streams.

	self
		assert: response code equals: 200;
		assert: response contents equals: self dataStreamsSnapshotAsJSON
]

{ #category : #tests }
DataAPITest >> testQueryingStreamByName [

	| interface response |

	interface := DataAPI workingWithin: rootSystem.
	response := interface streamNamed: 'Temperature'.

	self
		assert: response code equals: 200;
		assert: response contents equals: self temperatureDataStreamAsJSON
]

{ #category : #tests }
DataAPITest >> testQueryingStreamByNameGivesNotFouldIfNotExists [

	| interface stream |

	interface := DataAPI workingWithin: rootSystem.

	self
		should:
			[ stream := interface streamNamed: 'pH' ]
		raise: HTTPClientError
		withDescription: 'Not found'
]

{ #category : #accessing }
DataAPITest >> updateTemperatureAndPressureDataStreamsJSON [

	^ '[
			{
				"data-stream" : "Temperature",
				"value" : 24
			},
			{
				"data-stream" : "Pressure",
				"value" : 89
			}
		]'
]
