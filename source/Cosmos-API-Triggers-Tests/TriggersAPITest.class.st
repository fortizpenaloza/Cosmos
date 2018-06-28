Class {
	#name : #TriggersAPITest,
	#superclass : #SystemBasedUserStoryTest,
	#instVars : [
		'interface'
	],
	#category : #'Cosmos-API-Triggers-Tests'
}

{ #category : #'tests support' }
TriggersAPITest >> assert: aResponse wasSuccessfulWithContentEqualsTo: aString [

	self
		assert: aResponse code equals: 200;
		assert: aResponse contents equals: (aString expandMacrosWith: TimeZones local offset)
]

{ #category : #accessing }
TriggersAPITest >> decemberTenthOf2016AtNoon [

	^ (December tenth , 2016) atNoon
]

{ #category : #accessing }
TriggersAPITest >> eightPM [
	
	^ TimeOfDay hours: 20
]

{ #category : #accessing }
TriggersAPITest >> fiveMinutes [

	^ TimeUnits minute with: 5
]

{ #category : #accessing }
TriggersAPITest >> getTriggersHttpRequest [

	^ (ZnRequest get: 'http://COSMOS_URL/v1/triggers')
		setAccept: self triggerMimeTypeVersion1dot0dot0
]

{ #category : #accessing }
TriggersAPITest >> ninePM [
	
	^ TimeOfDay hours: 21
]

{ #category : #accessing }
TriggersAPITest >> registerSetTriggeredToTrueAfterDataPointGreaterThanElevenWasRegisteredOnTemperature [

	self triggerManagementSystem
		registerNamed:
			'Set triggered to true after a data point greater than 11 was registered on Temperature'
		triggering: self setTriggedToTrue
		accordingTo: (DataPointRegistrationTriggeringPolicy on: self temperature)
		whenMeets:
			(DataStreamCurrentValueTriggeringCondition of: self temperature isGreaterThan: 11)
]

{ #category : #accessing }
TriggersAPITest >> registerSetTriggeredToTrueAfterDataPointWasRegisteredOnTemperature [

	self triggerManagementSystem
		registerNamed: 'Set triggered to true after a data point was registered on Temperature'
		triggering: self setTriggedToTrue
		accordingTo: (DataPointRegistrationTriggeringPolicy on: self temperature)
		whenMeets: AlwaysTriggeringCondition new
]

{ #category : #accessing }
TriggersAPITest >> registerSetTriggeredToTruePeriodicallyEveryFiveMinutes [

	self triggerManagementSystem
		registerNamed: 'Set triggered to true periodically every 5 minutes'
		triggering: self setTriggedToTrue
		accordingTo: (PeriodicalTriggeringPolicy every: self fiveMinutes)
		whenMeets: AlwaysTriggeringCondition new
]

{ #category : #accessing }
TriggersAPITest >> setTriggedToTrue [

	^ self actionManagementSystem
		actionNamed: 'Set triggered to true'
		ifFound: [ :action | action ]
		ifNone: [ ObjectNotFound signal: 'Action not found' ]
]

{ #category : #running }
TriggersAPITest >> setUp [

	super setUp.

	interface := (TriggersAPIInstaller toInstallOn: Teapot on workingWith: rootSystem)
		install.

	(SensorsSampleAddOn on: rootSystem) install.

	self actionManagementSystem
		registerNamed: 'Set triggered to true'
		toEvaluate: (BlockEvaluationPolicy for: [ "Do nothing" ])
]

{ #category : #running }
TriggersAPITest >> setUpRequirements [

	super
		setUpRequirements;
		requireDataManagementSystem;
		requireActionManagementSystem;
		requireTriggerManagementSystem
 
]

{ #category : #accessing }
TriggersAPITest >> temperature [

	^ self dataManagementSystem 
		streamNamed: 'Temperature'
		ifFound: [ :stream | stream ]
		ifNone: [ ObjectNotFound signal: 'Data stream not found' ]
]

{ #category : #accessing }
TriggersAPITest >> tenMinutes [

	^ TimeUnits minute with: 10
]

{ #category : #tests }
TriggersAPITest >> testGettingTriggers [

	| response |

	self
		registerSetTriggeredToTrueAfterDataPointWasRegisteredOnTemperature;
		registerSetTriggeredToTruePeriodicallyEveryFiveMinutes.

	response := interface triggersFor: self getTriggersHttpRequest.

	self
		assert: response
		wasSuccessfulWithContentEqualsTo:
			'[
	{
		"name" : "Set triggered to true after a data point was registered on Temperature",
		"created_on" : "2015-09-06T12:00:00<1p>",
		"action" : "Set triggered to true",
		"policy" : {
			"type" : "on_data_point_registration",
			"data_stream" : "Temperature"
		},
		"conditions" : [ ]
	},
	{
		"name" : "Set triggered to true periodically every 5 minutes",
		"created_on" : "2015-09-06T12:00:00<1p>",
		"action" : "Set triggered to true",
		"policy" : {
			"type" : "periodical",
			"time_interval" : "5 minutes"
		},
		"conditions" : [ ]
	}
]'
]

{ #category : #tests }
TriggersAPITest >> testGettingTriggersFailsWhenRequestingInvalidResourceVersion [

	self registerSetTriggeredToTrueAfterDataPointWasRegisteredOnTemperature.

	self
		should: [ interface
				triggersFor:
					((ZnRequest get: 'http://COSMOS_URL/v1/triggers')
						setAccept: (ZnMimeType fromString: 'application/vnd.cosmos.trigger+json; version=1.2.0')) ]
		raise: HTTPClientError
		withExceptionDo:
			[ :signal | self assert: signal messageText equals: 'Encoder not found for given schema' ]
]

{ #category : #tests }
TriggersAPITest >> testGettingTriggersIncludesSetTriggeredToTrueAfterDataPointWasRegisteredOnTemperature [

	| response |

	self registerSetTriggeredToTrueAfterDataPointWasRegisteredOnTemperature.

	response := interface triggersFor: self getTriggersHttpRequest.

	self
		assert: response isSuccess;
		assert: response contents
			equals:
			('[
	{
		"name" : "Set triggered to true after a data point was registered on Temperature",
		"created_on" : "2015-09-06T12:00:00<1p>",
		"action" : "Set triggered to true",
		"policy" : {
			"type" : "on_data_point_registration",
			"data_stream" : "Temperature"
		},
		"conditions" : [ ]
	}
]' expandMacrosWith: TimeZones local offset)
]

{ #category : #tests }
TriggersAPITest >> testQueryingTriggersIncludesSetTriggeredToTrueAfterDataPointWasRegisteredOnTemperatureAndItsGreaterThanEleven [

	| response |

	self
		registerSetTriggeredToTrueAfterDataPointGreaterThanElevenWasRegisteredOnTemperature.

	response := interface triggersFor: self getTriggersHttpRequest.
	self
		assert: response isSuccess;
		assert: response contents
			equals:
			('[
	{
		"name" : "Set triggered to true after a data point greater than 11 was registered on Temperature",
		"created_on" : "2015-09-06T12:00:00<1p>",
		"action" : "Set triggered to true",
		"policy" : {
			"type" : "on_data_point_registration",
			"data_stream" : "Temperature"
		},
		"conditions" : [
			{
				"type" : "data_stream_current_value",
				"data_stream" : "Temperature",
				"condition" : {
					"operator" : ">",
					"value" : 11
				}
			}
		]
	}
]' expandMacrosWith: TimeZones local offset)
]

{ #category : #tests }
TriggersAPITest >> testQueryingTriggersIncludesSetTriggeredToTrueAfterDataPointWasRegisteredOnTemperatureAndItsGreaterThanElevenBetweenEightAndNinePM [

	| response |

	self triggerManagementSystem
		registerNamed: 'Set triggered to true after a data point greater than 11 was registered on Temperature if current time is between 8PM and 9PM'
		triggering: self setTriggedToTrue
		accordingTo: (DataPointRegistrationTriggeringPolicy on: self temperature)
		whenMeets:
			(AndCompositeTriggeringCondition
				with: (DataStreamCurrentValueTriggeringCondition of: self temperature isGreaterThan: 11)
				with:
					(TimeIntervalTriggeringCondition
						checkingCurrentTimeIsBetween: (self eightPM to: self ninePM))).

	response := interface triggersFor: self getTriggersHttpRequest.
	self
		assert: response isSuccess;
		assert: response contents
			equals:
			('[
	{
		"name" : "Set triggered to true after a data point greater than 11 was registered on Temperature if current time is between 8PM and 9PM",
		"created_on" : "2015-09-06T12:00:00<1p>",
		"action" : "Set triggered to true",
		"policy" : {
			"type" : "on_data_point_registration",
			"data_stream" : "Temperature"
		},
		"conditions" : [
			{
				"type" : "data_stream_current_value",
				"data_stream" : "Temperature",
				"condition" : {
					"operator" : ">",
					"value" : 11
				}
			},
			{
				"type" : "time_interval",
				"from" : "20:00:00",
				"to" : "21:00:00"
			}
		]
	}
]' expandMacrosWith: TimeZones local offset)
]

{ #category : #tests }
TriggersAPITest >> testQueryingTriggersIncludesTriggeredToTruePeriodicallyEveryFiveMinutes [

	| response |

	self registerSetTriggeredToTruePeriodicallyEveryFiveMinutes.

	response := interface triggersFor: self getTriggersHttpRequest.

	self
		assert: response isSuccess;
		assert: response contents
			equals:
			('[
	{
		"name" : "Set triggered to true periodically every 5 minutes",
		"created_on" : "2015-09-06T12:00:00<1p>",
		"action" : "Set triggered to true",
		"policy" : {
			"type" : "periodical",
			"time_interval" : "5 minutes"
		},
		"conditions" : [ ]
	}
]' expandMacrosWith: TimeZones local offset)
]

{ #category : #tests }
TriggersAPITest >> testRegistrationOfDataPointRegistered [

	| response |

	self triggerManagementSystem
		triggerNamed: 'Set triggered to true on data point registration'
		ifFound: [ :trigger | self fail ]
		ifNone: [ "do nothing" ].

	response := interface
		registerFrom:
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
						type: self triggerMimeTypeVersion1dot0dot0)).

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
TriggersAPITest >> testRegistrationOfPeriodicalTrigger [

	| response |
	self triggerManagementSystem
		triggerNamed: 'Set triggered to true periodically every 5 minutes'
		ifFound: [ :trigger | self fail ]
		ifNone: [ "do nothing" ].

	response := interface
		registerFrom:
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
						type: self triggerMimeTypeVersion1dot0dot0)).
						
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

{ #category : #accessing }
TriggersAPITest >> triggerMimeTypeVersion1dot0dot0 [

	^ ZnMimeType
		fromString: 'application/vnd.cosmos.trigger+json; version=1.0.0'
]
