Class {
	#name : #TriggersRESTfulWebServiceTest,
	#superclass : #SystemBasedUserStoryTest,
	#instVars : [
		'webService'
	],
	#category : #'Cosmos-API-Triggers-Tests'
}

{ #category : #accessing }
TriggersRESTfulWebServiceTest >> applicationJsonVersion1dot0dot0 [

	^ 'application/json;version=1.0.0' asZnMimeType
]

{ #category : #'tests support' }
TriggersRESTfulWebServiceTest >> assert: aResponse wasSuccessfulWithContentEqualsTo: aString [

	self
		assert: aResponse code equals: 200;
		assert: aResponse contents equals: aString
]

{ #category : #accessing }
TriggersRESTfulWebServiceTest >> dateTimeFormattedAsISO8601 [

	^ ISO8601DateTimeFormatter usingExtendedFormat
		format: self systemDateTime
]

{ #category : #accessing }
TriggersRESTfulWebServiceTest >> eightPM [
	
	^ TimeOfDay hours: 20
]

{ #category : #accessing }
TriggersRESTfulWebServiceTest >> fiveMinutes [

	^ TimeUnits minute with: 5
]

{ #category : #accessing }
TriggersRESTfulWebServiceTest >> getTriggersHttpRequest [

	^ (ZnRequest get: 'http://COSMOS_URL/v1/triggers')
		setAccept: self applicationJsonVersion1dot0dot0
]

{ #category : #accessing }
TriggersRESTfulWebServiceTest >> httpRequestContext [

	^ HttpRequestContext new
]

{ #category : #accessing }
TriggersRESTfulWebServiceTest >> ninePM [
	
	^ TimeOfDay hours: 21
]

{ #category : #accessing }
TriggersRESTfulWebServiceTest >> registerSetTriggeredToTrueAfterDataPointGreaterThanElevenWasRegisteredOnTemperature [

	self triggerManagementSystem
		registerNamed:
			'Set triggered to true after a data point greater than 11 was registered on Temperature'
		triggering: self setTriggedToTrue
		accordingTo: (DataPointRegistrationTriggeringPolicy on: self temperature)
		whenMeets:
			(DataStreamCurrentValueTriggeringCondition of: self temperature isGreaterThan: 11)
]

{ #category : #accessing }
TriggersRESTfulWebServiceTest >> registerSetTriggeredToTrueAfterDataPointWasRegisteredOnTemperature [

	self triggerManagementSystem
		registerNamed: 'Set triggered to true after a data point was registered on Temperature'
		triggering: self setTriggedToTrue
		accordingTo: (DataPointRegistrationTriggeringPolicy on: self temperature)
		whenMeets: AlwaysTriggeringCondition new
]

{ #category : #accessing }
TriggersRESTfulWebServiceTest >> registerSetTriggeredToTruePeriodicallyEveryFiveMinutes [

	self triggerManagementSystem
		registerNamed: 'Set triggered to true periodically every 5 minutes'
		triggering: self setTriggedToTrue
		accordingTo: (PeriodicalTriggeringPolicy every: self fiveMinutes)
		whenMeets: AlwaysTriggeringCondition new
]

{ #category : #accessing }
TriggersRESTfulWebServiceTest >> setTriggedToTrue [

	^ self actionManagementSystem
		actionNamed: 'Set triggered to true'
		ifFound: [ :action | action ]
		ifNone: [ ObjectNotFound signal: 'Action not found' ]
]

{ #category : #running }
TriggersRESTfulWebServiceTest >> setUp [

	super setUp.

	webService := TriggersRESTfulWebService workingWith: rootSystem.

	(SensorsSampleAddOn on: rootSystem) install.

	self actionManagementSystem
		register:
			(Action
				named: 'Set triggered to true'
				evaluating: (EvaluateBlockPolicy for: [ "Do nothing" ]))
]

{ #category : #running }
TriggersRESTfulWebServiceTest >> setUpRequirements [

	super
		setUpRequirements;
		requireDataManagementSystem;
		requireActionManagementSystem;
		requireTriggerManagementSystem
 
]

{ #category : #accessing }
TriggersRESTfulWebServiceTest >> temperature [

	^ self dataManagementSystem 
		streamNamed: 'Temperature'
		ifFound: [ :stream | stream ]
		ifNone: [ ObjectNotFound signal: 'Data stream not found' ]
]

{ #category : #tests }
TriggersRESTfulWebServiceTest >> testGetTriggers [

	| response |

	self
		registerSetTriggeredToTrueAfterDataPointWasRegisteredOnTemperature;
		registerSetTriggeredToTruePeriodicallyEveryFiveMinutes.

	response := webService
		getTriggersBasedOn: self getTriggersHttpRequest
		within: self httpRequestContext.

	self
		assert: response
		wasSuccessfulWithContentEqualsTo:
			('[{"name":"Set triggered to true after a data point was registered on Temperature","created_on":"<1s>","action":"Set triggered to true","policy":{"type":"on_data_point_registration","data_stream":"Temperature"},"conditions":[]},{"name":"Set triggered to true periodically every 5 minutes","created_on":"<1s>","action":"Set triggered to true","policy":{"type":"periodical","time_interval":"5 minutes"},"conditions":[]}]'
				expandMacrosWith: self dateTimeFormattedAsISO8601)
]

{ #category : #tests }
TriggersRESTfulWebServiceTest >> testGettingTriggersFailsWhenRequestingInvalidResourceVersion [

	self
		registerSetTriggeredToTrueAfterDataPointWasRegisteredOnTemperature.

	self
		should: [ webService
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
				equals: 'Encoder not found for given media type' ]
]

{ #category : #tests }
TriggersRESTfulWebServiceTest >> testGettingTriggersIncludesSetTriggeredToTrueAfterDataPointWasRegisteredOnTemperature [

	| response |

	self
		registerSetTriggeredToTrueAfterDataPointWasRegisteredOnTemperature.

	response := webService
		getTriggersBasedOn: self getTriggersHttpRequest
		within: self httpRequestContext.

	self
		assert: response isSuccess;
		assert: response contents
			equals:
			('[{"name":"Set triggered to true after a data point was registered on Temperature","created_on":"<1s>","action":"Set triggered to true","policy":{"type":"on_data_point_registration","data_stream":"Temperature"},"conditions":[]}]'
				expandMacrosWith: self dateTimeFormattedAsISO8601)
]

{ #category : #tests }
TriggersRESTfulWebServiceTest >> testQueryingTriggersIncludesSetTriggeredToTrueAfterDataPointWasRegisteredOnTemperatureAndItsGreaterThanEleven [

	| response |

	self
		registerSetTriggeredToTrueAfterDataPointGreaterThanElevenWasRegisteredOnTemperature.

	response := webService
		getTriggersBasedOn: self getTriggersHttpRequest
		within: self httpRequestContext.
	self
		assert: response isSuccess;
		assert: response contents
			equals:
			('[{"name":"Set triggered to true after a data point greater than 11 was registered on Temperature","created_on":"<1s>","action":"Set triggered to true","policy":{"type":"on_data_point_registration","data_stream":"Temperature"},"conditions":[{"type":"data_stream_current_value","data_stream":"Temperature","condition":{"operator":">","value":11}}]}]'
				expandMacrosWith: self dateTimeFormattedAsISO8601)
]

{ #category : #tests }
TriggersRESTfulWebServiceTest >> testQueryingTriggersIncludesSetTriggeredToTrueAfterDataPointWasRegisteredOnTemperatureAndItsGreaterThanElevenBetweenEightAndNinePM [

	| response |

	self triggerManagementSystem
		registerNamed:
			'Set triggered to true after a data point greater than 11 was registered on Temperature if current time is between 8PM and 9PM'
		triggering: self setTriggedToTrue
		accordingTo: (DataPointRegistrationTriggeringPolicy on: self temperature)
		whenMeets:
			(AndCompositeTriggeringCondition
				with:
					(DataStreamCurrentValueTriggeringCondition
						of: self temperature
						isGreaterThan: 11)
				with:
					(TimeIntervalTriggeringCondition
						checkingCurrentTimeIsBetween: (self eightPM to: self ninePM))).

	response := webService
		getTriggersBasedOn: self getTriggersHttpRequest
		within: self httpRequestContext.
	self
		assert: response isSuccess;
		assert: response contents
			equals:
			('[{"name":"Set triggered to true after a data point greater than 11 was registered on Temperature if current time is between 8PM and 9PM","created_on":"<1s>","action":"Set triggered to true","policy":{"type":"on_data_point_registration","data_stream":"Temperature"},"conditions":[{"type":"data_stream_current_value","data_stream":"Temperature","condition":{"operator":">","value":11}},{"type":"time_interval","from":"20:00:00","to":"21:00:00"}]}]'
				expandMacrosWith: self dateTimeFormattedAsISO8601)
]

{ #category : #tests }
TriggersRESTfulWebServiceTest >> testQueryingTriggersIncludesTriggeredToTruePeriodicallyEveryFiveMinutes [

	| response |

	self registerSetTriggeredToTruePeriodicallyEveryFiveMinutes.

	response := webService
		getTriggersBasedOn: self getTriggersHttpRequest
		within: self httpRequestContext.

	self
		assert: response isSuccess;
		assert: response contents
			equals:
			('[{"name":"Set triggered to true periodically every 5 minutes","created_on":"<1s>","action":"Set triggered to true","policy":{"type":"periodical","time_interval":"5 minutes"},"conditions":[]}]'
				expandMacrosWith: self dateTimeFormattedAsISO8601)
]

{ #category : #tests }
TriggersRESTfulWebServiceTest >> testRegistrationOfDataPointRegistered [

	| response |

	self triggerManagementSystem
		triggerNamed: 'Set triggered to true on data point registration'
		ifFound: [ :trigger | self fail ]
		ifNone: [ "do nothing" ].

	response := webService
		registerHandling:
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
						type: self applicationJsonVersion1dot0dot0)).

	self
		assert: response code equals: 201;
		assert: response location equals: 'http://cosmos_url/v1/triggers'.

	self triggerManagementSystem
		triggerNamed: 'Set triggered to true on data point registration'
		ifFound: [ :trigger | 
			self
				assert: trigger name
					equals: 'Set triggered to true on data point registration';
				assert: trigger creationDateTime equals: self timeSystem dateTime ]
		ifNone: [ self fail ]
]

{ #category : #tests }
TriggersRESTfulWebServiceTest >> testRegistrationOfPeriodicalTrigger [

	| response |
	self triggerManagementSystem
		triggerNamed: 'Set triggered to true periodically every 5 minutes'
		ifFound: [ :trigger | self fail ]
		ifNone: [ "do nothing" ].

	response := webService
		registerHandling:
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
						type: self applicationJsonVersion1dot0dot0)).
						
	self
		assert: response code equals: 201;
		assert: response location equals: 'http://cosmos_url/v1/triggers'.

	self triggerManagementSystem
		triggerNamed: 'Set triggered to true periodically every 5 minutes'
		ifFound: [ :trigger | 
			self
				assert: trigger name
					equals: 'Set triggered to true periodically every 5 minutes';
				assert: trigger creationDateTime equals: self timeSystem dateTime ]
		ifNone: [ self fail ]
]

{ #category : #tests }
TriggersRESTfulWebServiceTest >> testRoutesConfiguration [

	| teapot |

	teapot := Teapot on.
	(TriggersRESTfulWebServiceSpecification toInstallOn: teapot workingWith: self) install.

	self assert: teapot routes size equals: 3
]
