Class {
	#name : #TriggersRESTfulControllerTest,
	#superclass : #SystemBasedUserStoryTest,
	#instVars : [
		'resourceController'
	],
	#category : #'Cosmos-API-Triggers-Tests'
}

{ #category : #accessing }
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

{ #category : #accessing }
TriggersRESTfulControllerTest >> dateTimeFormattedAsISO8601 [

	^ ISO8601DateTimeFormatter usingExtendedFormat
		format: self systemDateTime
]

{ #category : #accessing }
TriggersRESTfulControllerTest >> eightPM [
	
	^ TimeOfDay hours: 20
]

{ #category : #accessing }
TriggersRESTfulControllerTest >> fiveMinutes [

	^ TimeUnits minute with: 5
]

{ #category : #accessing }
TriggersRESTfulControllerTest >> getTriggersHttpRequest [

	^ (ZnRequest get: resourceController specification endpoint)
		setAccept: self applicationJsonVersion1dot0dot0MediaType
]

{ #category : #accessing }
TriggersRESTfulControllerTest >> httpRequestContext [

	^ HttpRequestContext new
]

{ #category : #accessing }
TriggersRESTfulControllerTest >> ninePM [
	
	^ TimeOfDay hours: 21
]

{ #category : #accessing }
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

{ #category : #accessing }
TriggersRESTfulControllerTest >> registerSetTriggeredToTrueAfterDataPointWasRegisteredOnTemperature [

	self triggerManagementSystem
		register: (self setTriggeredToTrueAfterDataPointRegistrationOn: self temperatureStream)
]

{ #category : #accessing }
TriggersRESTfulControllerTest >> registerSetTriggeredToTruePeriodicallyEveryFiveMinutes [

	self triggerManagementSystem register: (self setTriggeredToTrueEvery: self fiveMinutes)
]

{ #category : #'private - accessing' }
TriggersRESTfulControllerTest >> resourceUrl [

	^ self baseUrl / resourceController specification endpoint
]

{ #category : #accessing }
TriggersRESTfulControllerTest >> setTriggeredToTrue [

	^ self actionManagementSystem
		actionNamed: 'Set triggered to true'
		ifFound: [ :action | action ]
		ifNone: [ ObjectNotFound signal: 'Action not found' ]
]

{ #category : #accessing }
TriggersRESTfulControllerTest >> setTriggeredToTrueAfterDataPointRegistrationOn: aDataStream [

	^ ActionTrigger
		named: 'Set triggered to true after data point registration'
		triggering: self setTriggeredToTrue
		accordingTo: (DataPointRegistrationTriggeringPolicy on: aDataStream)
		ifSatisfies: AlwaysTriggeringCondition new
]

{ #category : #accessing }
TriggersRESTfulControllerTest >> setTriggeredToTrueEvery: aTimePeriod [

	^ self setTriggeredToTrueEvery: aTimePeriod ifSatisfies: AlwaysTriggeringCondition new
]

{ #category : #accessing }
TriggersRESTfulControllerTest >> setTriggeredToTrueEvery: aTimePeriod ifSatisfies: aCondition [

	^ ActionTrigger
		named: ('Set triggered to true every <1p>' expandMacrosWith: aTimePeriod)
		triggering: self setTriggeredToTrue
		accordingTo: (PeriodicalTriggeringPolicy every: aTimePeriod)
		ifSatisfies: aCondition
]

{ #category : #running }
TriggersRESTfulControllerTest >> setUp [

	super setUp.

	resourceController := TriggersRESTfulController workingWith: rootSystem.
	resourceController serverUrl: self baseUrl asZnUrl.

	(SensorsSampleAddOn on: rootSystem) install.

	self actionManagementSystem
		register:
			(Action
				named: 'Set triggered to true'
				evaluating: (EvaluateBlockPolicy for: [ "Do nothing" ]))
]

{ #category : #running }
TriggersRESTfulControllerTest >> setUpRequirements [

	super
		setUpRequirements;
		requireDataManagementSystem;
		requireActionManagementSystem;
		requireTriggerManagementSystem
 
]

{ #category : #accessing }
TriggersRESTfulControllerTest >> temperatureStream [

	^ self dataManagementSystem 
		streamNamed: 'Temperature'
		ifFound: [ :stream | stream ]
		ifNone: [ ObjectNotFound signal: 'Data stream not found' ]
]

{ #category : #tests }
TriggersRESTfulControllerTest >> testGetTriggerIncludesSetTriggeredToTrueAfterDataPointWasRegisteredOnTemperatureJustCreated [

	| response |

	self registerSetTriggeredToTrueAfterDataPointWasRegisteredOnTemperature.

	response := resourceController
		getTriggersBasedOn: self getTriggersHttpRequest
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
		getTriggersBasedOn: self getTriggersHttpRequest
		within: self httpRequestContext.

	self
		assert: response
		wasSuccessfulWithContentEqualsTo:
			('[{"name":"Set triggered to true after data point registration","action":"Set triggered to true","policy":{"type":"on_data_point_registration","data_stream":"Temperature"},"conditions":[]},{"name":"Set triggered to true every 5 minutes","action":"Set triggered to true","policy":{"type":"periodical","time_interval":"5 minutes"},"conditions":[]}]'
				expandMacrosWith: self dateTimeFormattedAsISO8601)
]

{ #category : #tests }
TriggersRESTfulControllerTest >> testGettingTriggersFailsWhenRequestingInvalidResourceVersion [

	self
		registerSetTriggeredToTrueAfterDataPointWasRegisteredOnTemperature.

	self
		should: [ resourceController
				getTriggersBasedOn:
					((ZnRequest get: 'http://COSMOS_URL/v1/triggers')
						setAccept:
							(ZnMimeType
								fromString: 'application/vnd.cosmos.trigger+json; version=1.2.0'))
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
		getTriggersBasedOn: self getTriggersHttpRequest
		within: self httpRequestContext.
	self
		assert: response isSuccess;
		assert: response contents
			equals:
			('[{"name":"Set triggered to true after a data point greater than 11 was registered on Temperature","action":"Set triggered to true","policy":{"type":"on_data_point_registration","data_stream":"Temperature"},"conditions":[{"type":"data_stream_current_value","data_stream":"Temperature","condition":{"operator":">","value":11}}]}]'
				expandMacrosWith: self dateTimeFormattedAsISO8601)
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
						with:
							(DataStreamCurrentValueTriggeringCondition
								of: self temperatureStream
								isGreaterThan: 11)
						with:
							(TimeIntervalTriggeringCondition
								checkingCurrentTimeIsBetween: (self eightPM to: self ninePM)))).

	response := resourceController
		getTriggersBasedOn: self getTriggersHttpRequest
		within: self httpRequestContext.
	self
		assert: response isSuccess;
		assert: response contents
			equals:
			('[{"name":"Set triggered to true after a data point greater than 11 was registered on Temperature if current time is between 8PM and 9PM","action":"Set triggered to true","policy":{"type":"on_data_point_registration","data_stream":"Temperature"},"conditions":[{"type":"data_stream_current_value","data_stream":"Temperature","condition":{"operator":">","value":11}},{"type":"time_interval","from":"20:00:00","to":"21:00:00"}]}]'
				expandMacrosWith: self dateTimeFormattedAsISO8601)
]

{ #category : #tests }
TriggersRESTfulControllerTest >> testQueryingTriggersIncludesTriggeredToTruePeriodicallyEveryFiveMinutes [

	| response |

	self registerSetTriggeredToTruePeriodicallyEveryFiveMinutes.

	response := resourceController
		getTriggersBasedOn: self getTriggersHttpRequest
		within: self httpRequestContext.

	self
		assert: response isSuccess;
		assert: response contents
			equals:
			('[{"name":"Set triggered to true every 5 minutes","action":"Set triggered to true","policy":{"type":"periodical","time_interval":"5 minutes"},"conditions":[]}]'
				expandMacrosWith: self dateTimeFormattedAsISO8601)
]

{ #category : #tests }
TriggersRESTfulControllerTest >> testRegistrationOfDataPointRegistered [

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
		assert: response location equals: 'https://tests.cosmos.com/triggers/1'.

	self triggerManagementSystem
		triggerNamed: 'Set triggered to true on data point registration'
		ifFound: [ :trigger | 
			self
				assert: trigger name
					equals: 'Set triggered to true on data point registration' ]
		ifNone: [ self fail ]
]

{ #category : #tests }
TriggersRESTfulControllerTest >> testRegistrationOfPeriodicalTrigger [

	| response |

	self triggerManagementSystem
		triggerNamed: 'Set triggered to true periodically every 5 minutes'
		ifFound: [ :trigger | self fail ]
		ifNone: [ "do nothing" ].

	response := resourceController
		createTriggerBasedOn:
			((ZnRequest post: 'http://COSMOS_URL/v1/triggers')
				entity:
					(ZnEntity
						with:
							'{
	"name" : "Set triggered to true periodically every 5 minutes",
	"action" : "Set triggered to true",
	"policy" : {
		"type" : "periodical",
		"time_interval" : "00:05:00"
	},
	"conditions" : [ ]
}'
						type: self applicationJsonVersion1dot0dot0MediaType))
		within: self httpRequestContext.

	self
		assert: response code equals: 201;
		assert: response location equals: 'https://tests.cosmos.com/triggers/1'.

	self triggerManagementSystem
		triggerNamed: 'Set triggered to true periodically every 5 minutes'
		ifFound: [ :trigger | 
			self
				assert: trigger name
					equals: 'Set triggered to true periodically every 5 minutes' ]
		ifNone: [ self fail ]
]
