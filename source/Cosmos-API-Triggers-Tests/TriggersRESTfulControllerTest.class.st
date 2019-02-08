Class {
	#name : #TriggersRESTfulControllerTest,
	#superclass : #SystemBasedRESTfulControllerUserStoryTest,
	#category : #'Cosmos-API-Triggers-Tests'
}

{ #category : #'private - media types' }
TriggersRESTfulControllerTest >> applicationJsonVersion1dot0dot0MediaType [

	^ 'application/json;version=1.0.0' asMediaType
]

{ #category : #'tests support' }
TriggersRESTfulControllerTest >> assert: aResponse wasSuccessfulWithContentEqualsTo: aString [

	self
		assert: aResponse code equals: 200;
		assert: aResponse contents equals: aString
]

{ #category : #'private - accessing' }
TriggersRESTfulControllerTest >> baseUrl [

	^ 'https://tests.cosmos.com' asZnUrl
]

{ #category : #'private - accessing' }
TriggersRESTfulControllerTest >> eightPM [
	
	^ TimeOfDay hours: 20
]

{ #category : #'private - accessing' }
TriggersRESTfulControllerTest >> fiveMinutes [

	^ TimeUnits minute with: 5
]

{ #category : #'private - accessing' }
TriggersRESTfulControllerTest >> identifierProvider [

	^ SequentialIdentifierProvider providing: self identifierSequence 
]

{ #category : #'private - accessing' }
TriggersRESTfulControllerTest >> identifierSequence [

	^ {(UUID fromString: 'ab203809-4537-0d00-96a8-67bd07fa2cfc').
	(UUID fromString: 'c3e53a0a-4537-0d00-96a9-ad5f07fa2cfc').
	(UUID fromString: '6fbb430b-4537-0d00-96aa-582b07fa2cfc').
	(UUID fromString: '62ede40b-4537-0d00-96ab-a32d07fa2cfc').
	self setTriggeredToTrueIdentifier.
	(UUID fromString: '1a8f38f0-7e37-0d00-9bcd-a0b00988c858')}
]

{ #category : #'private - accessing' }
TriggersRESTfulControllerTest >> ninePM [
	
	^ TimeOfDay hours: 21
]

{ #category : #'private - accessing' }
TriggersRESTfulControllerTest >> registerSetTriggeredToTrueAfterDataPointGreaterThanElevenWasRegisteredOnTemperature [

	self triggerManagementSystem
		register:
			(ActionTrigger
				named:
					'Set triggered to true after a data point greater than 11 was registered on Temperature'
				triggering: self setTriggeredToTrue
				accordingTo: (DataPointRegistrationTriggeringPolicy on: self temperatureStream)
				ifSatisfies:
					(DataStreamCurrentValueTriggeringCondition
						of: self temperatureStream
						isGreaterThan: 11))
]

{ #category : #'private - accessing' }
TriggersRESTfulControllerTest >> registerSetTriggeredToTrueAfterDataPointWasRegisteredOnTemperature [

	self triggerManagementSystem
		register:
			(self
				setTriggeredToTrueAfterDataPointRegistrationOn: self temperatureStream)
]

{ #category : #'private - accessing' }
TriggersRESTfulControllerTest >> registerSetTriggeredToTruePeriodicallyEveryFiveMinutes [

	self triggerManagementSystem register: (self setTriggeredToTrueEvery: self fiveMinutes)
]

{ #category : #'private - requests' }
TriggersRESTfulControllerTest >> requestToCreateTriggerFrom: aJSON [

	^ self requestToPost: aJSON as: self applicationJsonVersion1dot0dot0MediaType
]

{ #category : #'private - requests' }
TriggersRESTfulControllerTest >> requestToGetTriggerIdentifiedBy: anIdentifier accepting: aMediaType [

	^ self requestToGetResourceIdentifiedBy: anIdentifier accepting: aMediaType
]

{ #category : #'private - requests' }
TriggersRESTfulControllerTest >> requestToGetTriggersAccepting: aMediaType [

	^ self requestToGetResourcesAccepting: aMediaType 
]

{ #category : #'private - accessing' }
TriggersRESTfulControllerTest >> setTriggeredToTrue [

	^ self actionManagementSystem actionNamed: 'Set triggered to true'
]

{ #category : #'private - accessing' }
TriggersRESTfulControllerTest >> setTriggeredToTrueAfterDataPointRegistrationOn: aDataStream [

	^ ActionTrigger
		named: 'Set triggered to true after data point registration'
		triggering: self setTriggeredToTrue
		accordingTo: (DataPointRegistrationTriggeringPolicy on: aDataStream)
		ifSatisfies: AlwaysTriggeringCondition new
]

{ #category : #'private - accessing' }
TriggersRESTfulControllerTest >> setTriggeredToTrueEvery: aTimePeriod [

	^ self setTriggeredToTrueEvery: aTimePeriod ifSatisfies: AlwaysTriggeringCondition new
]

{ #category : #'private - accessing' }
TriggersRESTfulControllerTest >> setTriggeredToTrueEvery: aTimePeriod ifSatisfies: aCondition [

	^ ActionTrigger
		named: ('Set triggered to true every <1p>' expandMacrosWith: aTimePeriod)
		triggering: self setTriggeredToTrue
		accordingTo: (PeriodicalTriggeringPolicy every: aTimePeriod)
		ifSatisfies: aCondition
]

{ #category : #'private - accessing' }
TriggersRESTfulControllerTest >> setTriggeredToTrueIdentifier [

	^ UUID fromString: '98c4eaee-7e37-0d00-9bcc-cab60988c858'
]

{ #category : #running }
TriggersRESTfulControllerTest >> setUp [

	super setUp.

	(SensorsSampleAddOn on: rootSystem) install.

	self actionManagementSystem
		register:
			(Action
				named: 'Set triggered to true'
				evaluating: (EvaluateBlockPolicy for: [ "Do nothing" ]))
]

{ #category : #running }
TriggersRESTfulControllerTest >> setUpRequirements [

	self flag: 'super
		setUpRequirements;
		requireDataManagementSystem;
		requireActionManagementSystem;
		requireTriggerManagementSystem'.
		
	self
		registerSubsystem: (TimeSystem using: (FixedTimeSource on: self systemDateTime));
		registerSubsystem: EventNotificationSystem new;
		registerSubsystem: MetadataSystem new;
		registerSubsystem: (IdentifierSystem using: self identifierProvider);
		registerSubsystem: TimestampingSystem new;
		registerSubsystem: DataStreamManagementSystem new;
		registerSubsystem: ActionManagementSystem new;
		registerSubsystem: TriggerManagementSystem new
 
]

{ #category : #running }
TriggersRESTfulControllerTest >> setUpResourceController [

	resourceController := TriggersRESTfulController workingWith: rootSystem.

]

{ #category : #'private - accessing' }
TriggersRESTfulControllerTest >> systemDateTime [

	^ DateTime 
		date: October first , 2014 
		timeOfDay: TimeOfDay noon 
		zone: TimeZones buenosAires
]

{ #category : #'private - accessing' }
TriggersRESTfulControllerTest >> temperatureStream [

	^ self dataManagementSystem streamNamed: 'Temperature'
]

{ #category : #tests }
TriggersRESTfulControllerTest >> testCreateOnDataPointRegistrationTrigger [

	| response |

	self triggerManagementSystem
		triggerNamed: 'Set triggered to true on data point registration'
		ifFound: [ :trigger | self fail ]
		ifNone: [ "do nothing" ].

	response := resourceController
		createTriggerBasedOn:
			((ZnRequest post: 'http://COSMOS_URL/v1/triggers')
				entity:
					(ZnEntity
						with:
							'{
	"name" : "Set triggered to true on data point registration",
	"action" : "Set triggered to true",
	"policy" : {
		"type" : "data_point_registration",
		"data_stream" : "Temperature"
	},
	"conditions" : [ ]
}'
						type: self applicationJsonVersion1dot0dot0MediaType))
		within: self httpRequestContext.

	self
		assert: response code equals: 201;
		assert: response location equals: 'https://tests.cosmos.com/triggers/98c4eaee-7e37-0d00-9bcc-cab60988c858'.

	self triggerManagementSystem
		triggerNamed: 'Set triggered to true on data point registration'
		ifFound: [ :trigger | 
			self
				assert: trigger name
					equals: 'Set triggered to true on data point registration' ]
		ifNone: [ self fail ]
]

{ #category : #tests }
TriggersRESTfulControllerTest >> testCreatePeriodicalTrigger [

	| response |

	self triggerManagementSystem
		triggerNamed: 'Set triggered to true periodically every 5 minutes'
		ifFound: [ :trigger | self fail ]
		ifNone: [ "do nothing" ].

	response := resourceController
		createTriggerBasedOn:
			(self
				requestToCreateTriggerFrom:
					'{
	"name" : "Set triggered to true periodically every 5 minutes",
	"action" : "Set triggered to true",
	"policy" : {
		"type" : "periodical",
		"time_interval" : "5 minutes"
	},
	"conditions" : [ ]
}')
		within: self httpRequestContext.

	self
		assert: response isSuccess;
		assert: response code equals: 201;
		assert: response location
			equals: 'https://tests.cosmos.com/triggers/98c4eaee-7e37-0d00-9bcc-cab60988c858';
		assert: response contentType equals: self textPlainMediaType.

	self triggerManagementSystem
		triggerNamed: 'Set triggered to true periodically every 5 minutes'
		ifFound:
			[ :trigger | self assert: trigger name equals: 'Set triggered to true periodically every 5 minutes' ]
		ifNone: [ self fail ]
]

{ #category : #tests }
TriggersRESTfulControllerTest >> testDeleteTrigger [

	| response |

	self assert: self triggerManagementSystem triggers isEmpty.
	self registerSetTriggeredToTrueAfterDataPointWasRegisteredOnTemperature.
	self deny: self triggerManagementSystem triggers isEmpty.

	response := resourceController
		deleteTriggerBasedOn:
			(TeaRequest
				fromZnRequest: (ZnRequest delete: (self urlForResourceIdentifiedBy: self setTriggeredToTrueIdentifier))
				pathParams: {(#identifier -> self setTriggeredToTrueIdentifier)} asDictionary)
		within: self httpRequestContext.


	self
		assert: response isSuccess;
		assert: response status equals: 204;
		deny: response hasEntity;
		assert: self triggerManagementSystem triggers isEmpty
]

{ #category : #tests }
TriggersRESTfulControllerTest >> testGetTrigger [

	| response |

	self
		registerSetTriggeredToTrueAfterDataPointWasRegisteredOnTemperature.

	response := resourceController
		getTriggerBasedOn:
			(self
				requestToGetTriggerIdentifiedBy: self setTriggeredToTrueIdentifier
				accepting: self applicationJsonVersion1dot0dot0MediaType)
		within: self httpRequestContext.

	self
		assert: response isSuccess ;
		assert: response status equals: 200;
		assert: response contentType equals: self applicationJsonVersion1dot0dot0MediaType;
		assert: response entityTag equals: '"8fdd7769a8b44bd63f4b962583f13ef90e551344"' asETag;
		withJsonFromContentsIn: response contents
			do: [ :json | 
				self assert: json name equals: 'Set triggered to true after data point registration';
				assert: json action equals: 'Set triggered to true';
				assert: json policy type equals: 'on_data_point_registration';
				assert: json policy data_stream equals: 'Temperature';
				assert: json conditions isEmpty;
				assert: json links self equals: 'https://tests.cosmos.com/triggers/98c4eaee-7e37-0d00-9bcc-cab60988c858']
]

{ #category : #tests }
TriggersRESTfulControllerTest >> testGetTriggerIncludesSetTriggeredToTrueAfterDataPointWasRegisteredOnTemperatureJustCreated [

	| response |

	self registerSetTriggeredToTrueAfterDataPointWasRegisteredOnTemperature.

	response := resourceController
		getTriggersBasedOn: (self requestToGetTriggersAccepting: self applicationJsonVersion1dot0dot0MediaType)
		within: self httpRequestContext.

	self
		assert: response isSuccess;
		assert: response status equals: 200;
		assert: response contentType asZnMimeType equals: self applicationJsonVersion1dot0dot0MediaType.
	self
		withJsonFromContentsIn: response
		do: [ :json | 
			self
				withTheOnlyOneIn: json
				do: [ :rawTrigger | 
					self
						assert: rawTrigger name
							equals: 'Set triggered to true after data point registration';
						assert: rawTrigger policy data_stream equals: 'Temperature';
						assert: rawTrigger policy type equals: 'on_data_point_registration';
						assert: rawTrigger action equals: 'Set triggered to true';
						assert: rawTrigger conditions isEmpty ] ]
]

{ #category : #tests }
TriggersRESTfulControllerTest >> testGetTriggers [

	| response |

	self
		registerSetTriggeredToTrueAfterDataPointWasRegisteredOnTemperature;
		registerSetTriggeredToTruePeriodicallyEveryFiveMinutes.

	response := resourceController
		getTriggersBasedOn: (self requestToGetTriggersAccepting: self applicationJsonVersion1dot0dot0MediaType)
		within: self httpRequestContext.

	self
		assert: response
		wasSuccessfulWithContentEqualsTo:
			'[{"name":"Set triggered to true after data point registration","action":"Set triggered to true","policy":{"type":"on_data_point_registration","data_stream":"Temperature"},"conditions":[],"links":{"self":"https://tests.cosmos.com/triggers/98c4eaee-7e37-0d00-9bcc-cab60988c858"}},{"name":"Set triggered to true every 5 minutes","action":"Set triggered to true","policy":{"type":"periodical","time_interval":"5 minutes"},"conditions":[],"links":{"self":"https://tests.cosmos.com/triggers/1a8f38f0-7e37-0d00-9bcd-a0b00988c858"}}]'
]

{ #category : #tests }
TriggersRESTfulControllerTest >> testGettingTriggersFailsWhenRequestingInvalidResourceVersion [

	self registerSetTriggeredToTrueAfterDataPointWasRegisteredOnTemperature.

	self
		should: [ resourceController
				getTriggersBasedOn: (self requestToGetTriggersAccepting: 'application/json; version=1.2.0' asMediaType)
				within: self httpRequestContext ]
		raise: HTTPClientError
		withExceptionDo: [ :signal | 
			self
				assert: signal messageText
				equals: 'Cannot generate a response entity with acceptable characteristics.' ]
]

{ #category : #tests }
TriggersRESTfulControllerTest >> testQueryingTriggersIncludesSetTriggeredToTrueAfterDataPointWasRegisteredOnTemperatureAndItsGreaterThanEleven [

	| response |

	self registerSetTriggeredToTrueAfterDataPointGreaterThanElevenWasRegisteredOnTemperature.

	response := resourceController
		getTriggersBasedOn: (self requestToGetTriggersAccepting: self applicationJsonVersion1dot0dot0MediaType)
		within: self httpRequestContext.

	self
		assert: response isSuccess;
		assert: response contents
			equals:
			'[{"name":"Set triggered to true after a data point greater than 11 was registered on Temperature","action":"Set triggered to true","policy":{"type":"on_data_point_registration","data_stream":"Temperature"},"conditions":[{"type":"data_stream_current_value","data_stream":"Temperature","condition":{"operator":">","value":11}}],"links":{"self":"https://tests.cosmos.com/triggers/98c4eaee-7e37-0d00-9bcc-cab60988c858"}}]'
]

{ #category : #tests }
TriggersRESTfulControllerTest >> testQueryingTriggersIncludesSetTriggeredToTrueAfterDataPointWasRegisteredOnTemperatureAndItsGreaterThanElevenBetweenEightAndNinePM [

	| response |

	self triggerManagementSystem
		register:
			(ActionTrigger
				named:
					'Set triggered to true after a data point greater than 11 was registered on Temperature if current time is between 8PM and 9PM'
				triggering: self setTriggeredToTrue
				accordingTo: (DataPointRegistrationTriggeringPolicy on: self temperatureStream)
				ifSatisfies:
					(AndCompositeTriggeringCondition
						with: (DataStreamCurrentValueTriggeringCondition of: self temperatureStream isGreaterThan: 11)
						with: (TimeIntervalTriggeringCondition checkingCurrentTimeIsBetween: (self eightPM to: self ninePM)))).

	response := resourceController
		getTriggersBasedOn: (self requestToGetTriggersAccepting: self applicationJsonVersion1dot0dot0MediaType)
		within: self httpRequestContext.

	self
		assert: response isSuccess;
		assert: response contents
			equals:
			'[{"name":"Set triggered to true after a data point greater than 11 was registered on Temperature if current time is between 8PM and 9PM","action":"Set triggered to true","policy":{"type":"on_data_point_registration","data_stream":"Temperature"},"conditions":[{"type":"data_stream_current_value","data_stream":"Temperature","condition":{"operator":">","value":11}},{"type":"time_interval","from":"20:00:00","to":"21:00:00"}],"links":{"self":"https://tests.cosmos.com/triggers/98c4eaee-7e37-0d00-9bcc-cab60988c858"}}]'
]

{ #category : #tests }
TriggersRESTfulControllerTest >> testQueryingTriggersIncludesTriggeredToTruePeriodicallyEveryFiveMinutes [

	| response |

	self registerSetTriggeredToTruePeriodicallyEveryFiveMinutes.

	response := resourceController
		getTriggersBasedOn: (self requestToGetTriggersAccepting: self applicationJsonVersion1dot0dot0MediaType)
		within: self httpRequestContext.

	self
		assert: response isSuccess;
		assert: response contents
			equals:
			'[{"name":"Set triggered to true every 5 minutes","action":"Set triggered to true","policy":{"type":"periodical","time_interval":"5 minutes"},"conditions":[],"links":{"self":"https://tests.cosmos.com/triggers/98c4eaee-7e37-0d00-9bcc-cab60988c858"}}]'
]

{ #category : #'private - media types' }
TriggersRESTfulControllerTest >> textPlainMediaType [

	^ 'text/plain;charset=utf-8' asMediaType
]
