Class {
	#name : #DataPointsRESTfulControllerTest,
	#superclass : #SystemBasedUserStoryTest,
	#instVars : [
		'resourceController'
	],
	#category : #'Cosmos-API-Data-Tests'
}

{ #category : #'private - media types' }
DataPointsRESTfulControllerTest >> applicationJsonVersion1dot0dot0MediaType [

	^ 'application/json;version=1.0.0' asMediaType
]

{ #category : #'private - accessing' }
DataPointsRESTfulControllerTest >> baseUrl [

	^ 'https://tests.cosmos.com' asZnUrl
]

{ #category : #'private - accessing' }
DataPointsRESTfulControllerTest >> httpRequestContext [

	^ HttpRequestContext new
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

	^ (ZnRequest post: 'http://COSMOS_URL/v1/data-streams')
		entity: (ZnEntity with: aJson type: self applicationJsonVersion1dot0dot0MediaType)
]

{ #category : #running }
DataPointsRESTfulControllerTest >> setUp [

	super setUp.

	resourceController := DataPointsRESTfulController workingWith: rootSystem.
	resourceController serverUrl: self baseUrl asZnUrl.

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
				"data_stream" : "Temperature",
				"value" : 24
			},
			{
				"data_stream" : "Pressure",
				"value" : 89
			}
		]')
		within: self httpRequestContext.

	self
		assert: response isSuccess;
		assert: response status equals: 201;
		assert: response location equals: 'multiple';
		assert: response hasEntity;
		assert: temperature currentValue equals: 24;
		assert: pressure currentValue equals: 89
]

{ #category : #tests }
DataPointsRESTfulControllerTest >> testCreatingDataPointsGivesBadRequestWithMalformattedRequest [

	self
		should: [ resourceController
				createPointsBasedOn:
					(self
						requestToCreateDataPointsFrom:
							'{
  "data_stream": "xxx",
  "value": 24
}')
				within: self httpRequestContext ]
		raise: HTTPClientError
		withExceptionDo: [ :signal | 
			self
				assert: signal messageText
					equals: '[ expected';
				assert: signal code equals: 400 ]
]

{ #category : #tests }
DataPointsRESTfulControllerTest >> testCreatingDataPointsGivesBadRequestWithNotValidDataStream [

	self
		should: [ resourceController
				createPointsBasedOn:
					(self
						requestToCreateDataPointsFrom:
							'[
			{
				"data_stream" : "xxx",
				"value" : 24
			},
			{
				"data_stream" : "Pressure",
				"value" : 89
			}
		]')
				within: self httpRequestContext ]
		raise: HTTPClientError
		withExceptionDo: [ :signal | 
			self
				assert: signal messageText
					equals: 'Data stream named ''xxx'' not found';
				assert: signal code equals: 400 ]
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
		raise: HTTPClientError
		withExceptionDo: [ :signal | 
			self
				assert: signal messageText
					equals: 'key #data_stream not found in Dictionary';
				assert: signal code equals: 400 ]
]
