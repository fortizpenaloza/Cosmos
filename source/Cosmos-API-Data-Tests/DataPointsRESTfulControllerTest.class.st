Class {
	#name : #DataPointsRESTfulControllerTest,
	#superclass : #SystemBasedRESTfulControllerUserStoryTest,
	#category : #'Cosmos-API-Data-Tests'
}

{ #category : #'private - media types' }
DataPointsRESTfulControllerTest >> applicationJsonVersion1dot0dot0MediaType [

	^ resourceController applicationJSONVersion1dot0dot0MediaType
]

{ #category : #'private - accessing' }
DataPointsRESTfulControllerTest >> baseUrl [

	^ 'https://tests.cosmos.com' asZnUrl
]

{ #category : #'private - accessing' }
DataPointsRESTfulControllerTest >> identifierProvider [

	^ SequentialIdentifierProvider providing: self identifierSequence 
]

{ #category : #'private - accessing' }
DataPointsRESTfulControllerTest >> identifierSequence [

	^ {(UUID fromString: '29a17dd4-6637-0d00-bc60-582a0ae2e3e4')}
]

{ #category : #'private - accessing' }
DataPointsRESTfulControllerTest >> pressureStream [

	^ self dataManagementSystem streamNamed: 'Pressure'
]

{ #category : #'private - requests' }
DataPointsRESTfulControllerTest >> requestToCreateDataPointsFrom: aJson [

	^ self
		requestToPost: aJson
		as: self applicationJsonVersion1dot0dot0MediaType
]

{ #category : #running }
DataPointsRESTfulControllerTest >> setUp [

	super setUp.
	(SensorsSampleAddOn on: rootSystem) install
]

{ #category : #running }
DataPointsRESTfulControllerTest >> setUpRequirements [

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
DataPointsRESTfulControllerTest >> setUpResourceController [

	resourceController := DataPointsRESTfulController workingWith: rootSystem.

]

{ #category : #'private - accessing' }
DataPointsRESTfulControllerTest >> systemDateTime [

	^ DateTime 
		date: October first , 2014 
		timeOfDay: TimeOfDay noon 
		zone: TimeZones buenosAires
]

{ #category : #'private - accessing' }
DataPointsRESTfulControllerTest >> temperatureStream [

	^ self dataManagementSystem streamNamed: 'Temperature'
]

{ #category : #tests }
DataPointsRESTfulControllerTest >> testCreateDataPoints [

	| response temperature pressure |

	temperature := self temperatureStream.
	pressure := self pressureStream.

	self deny: temperature currentValue = 24.
	self deny: pressure currentValue = 89.

	response := resourceController
		createPointsBasedOn:
			(self
				requestToCreateDataPointsFrom:
					'[
			{
				"dataStream" : "Temperature",
				"value" : 24
			},
			{
				"dataStream" : "Pressure",
				"value" : 89
			}
		]')
		within: self httpRequestContext.

	self
		assert: response isSuccess;
		assert: response status equals: 201;
		assert: response location equals: 'https://tests.cosmos.com/data-points';
		assert: response hasEntity;
		assert: temperature currentValue equals: 24;
		assert: pressure currentValue equals: 89
]

{ #category : #tests }
DataPointsRESTfulControllerTest >> testCreatingDataPointsGivesBadRequestWithMalformattedRequest [

	self
		should: [ resourceController
				createPointsBasedOn:
					( self
						requestToCreateDataPointsFrom:
							'{
  "dataStream": "xxx",
  "value": 24
}' )
				within: self httpRequestContext
			]
		raise: HTTPClientError badRequest 
		withExceptionDo: [ :signal | 
			self
				assert: signal messageText equals: '[ expected';
				assert: signal code equals: 400
			]
]

{ #category : #tests }
DataPointsRESTfulControllerTest >> testCreatingDataPointsGivesBadRequestWithNotValidDataStream [

	self
		should: [ resourceController
				createPointsBasedOn:
					( self
						requestToCreateDataPointsFrom:
							'[
			{
				"dataStream" : "xxx",
				"value" : 24
			},
			{
				"dataStream" : "Pressure",
				"value" : 89
			}
		]' )
				within: self httpRequestContext
			]
		raise: HTTPClientError badRequest 
		withExceptionDo: [ :signal | 
			self
				assert: signal messageText equals: 'Data stream named ''xxx'' not found';
				assert: signal code equals: 400
			]
]

{ #category : #tests }
DataPointsRESTfulControllerTest >> testCreatingDataPointsGivesBadRequestWithNotValidKey [

	self
		should: [ resourceController
				createPointsBasedOn:
					(self
						requestToCreateDataPointsFrom:
							'[
			{
				"xxx" : "Temperature",
				"value" : 24
			},
			{
				"data_stream" : "Pressure",
				"value" : 89
			}
		]')
				within: self httpRequestContext ]
		raise: HTTPClientError badRequest 
		withExceptionDo: [ :signal | 
			self
				assert: signal messageText
					equals: 'key #dataStream not found in Dictionary';
				assert: signal code equals: 400 ]
]
