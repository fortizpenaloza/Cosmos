Class {
	#name : #TriggersAPITest,
	#superclass : #SystemBasedUserStoryTest,
	#instVars : [
		'interface'
	],
	#category : #'Cosmos-API-Triggers-Tests'
}

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
TriggersAPITest >> ninePM [
	
	^ TimeOfDay hours: 21
]

{ #category : #accessing }
TriggersAPITest >> setTriggedToTrue [

	^ Action
		named: 'Set triggered to true'
		createdOn: self decemberTenthOf2016AtNoon
		toEvaluate: (BlockEvaluationPolicy for: [ "do nothing" ])
]

{ #category : #initialization }
TriggersAPITest >> setUp [

	| setTriggeredToTrue |

	super setUp.

	interface := (TriggersAPIInstaller
		toInstallOn: Teapot on
		workingWith: rootSystem) install.

	(SensorsSampleAddOn on: rootSystem) install.

	setTriggeredToTrue := self actionManagementSystem
		registerNamed: 'Set triggered to true'
		toEvaluate: (BlockEvaluationPolicy for: [ "Do nothing" ])
]

{ #category : #initialization }
TriggersAPITest >> setUpRequirements [

	super
		setUpRequirements;
		requireDataManagementSystem;
		requireActionManagementSystem;
		requireTriggerManagementSystem
 
]

{ #category : #accessing }
TriggersAPITest >> temperature [
	
	^ DataStream named: 'Temperature' createdOn: self decemberTenthOf2016AtNoon 
]

{ #category : #accessing }
TriggersAPITest >> tenMinutes [

	^ TimeUnits minute with: 10
]

{ #category : #tests }
TriggersAPITest >> testQueryingTriggers [

	| response |
	
	self triggerManagementSystem
		registerNamed: 'Set triggered to true after data point regisration on Temperature'
		triggering: self setTriggedToTrue
		accordingTo: (DataPointRegistrationTriggeringPolicy on: self temperature)
		whenMeets: AlwaysTriggeringCondition new.

	self triggerManagementSystem
		registerNamed: 'Set triggered to true periodically every 5 minutes'
		triggering: self setTriggedToTrue
		accordingTo: (PeriodicalTriggeringPolicy every: self fiveMinutes)
		whenMeets: AlwaysTriggeringCondition new.

	response := interface triggersFor: ((ZnRequest get: 'http://COSMOS_URL/v1/triggers')
				setAccept: (ZnMimeType fromString: 'application/vnd.cosmos.trigger+json; version=1.0.0');
				yourself).

	self
		assert: response code equals: 200;
		assert: response contents equals: '[
	{
		"name" : "Set triggered to true after data point regisration on Temperature",
		"created_on" : "2015-09-06T12:00:00-03:00",
		"action" : "Set triggered to true",
		"policy" : {
			"type" : "on_data_point_registration",
			"data_stream" : "Temperature"
		},
		"conditions" : [ ]
	},
	{
		"name" : "Set triggered to true periodically every 5 minutes",
		"created_on" : "2015-09-06T12:00:00-03:00",
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
TriggersAPITest >> testQueryingTriggersIncludesSetTriggeredToTrueAfterDataPointWasRegisteredOnTemperature [

	| response |

	self triggerManagementSystem
		registerNamed: 'Set triggered to true after data point regisration on Temperature'
		triggering: self setTriggedToTrue
		accordingTo: (DataPointRegistrationTriggeringPolicy on: self temperature)
		whenMeets: AlwaysTriggeringCondition new.

	response := interface
		triggersFor:
			((ZnRequest get: 'http://COSMOS_URL/v1/triggers')
				setAccept: (ZnMimeType fromString: 'application/vnd.cosmos.trigger+json; version=1.0.0');
				yourself).
	self
		assert: response isSuccess;
		assert: response contents
			equals:
			('[
	{
		"name" : "Set triggered to true after data point regisration on Temperature",
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

	self triggerManagementSystem
		registerNamed: 'Set triggered to true after data point regisration on Temperature'
		triggering: self setTriggedToTrue
		accordingTo: (DataPointRegistrationTriggeringPolicy on: self temperature)
		whenMeets: (DataStreamCurrentValueTriggeringCondition of: self temperature isGreaterThan: 11).

	response := interface
		triggersFor:
			((ZnRequest get: 'http://COSMOS_URL/v1/triggers')
				setAccept: (ZnMimeType fromString: 'application/vnd.cosmos.trigger+json; version=1.0.0');
				yourself).
	self
		assert: response isSuccess;
		assert: response contents
			equals:
			('[
	{
		"name" : "Set triggered to true after data point regisration on Temperature",
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
		registerNamed: 'Set triggered to true after data point regisration on Temperature'
		triggering: self setTriggedToTrue
		accordingTo: (DataPointRegistrationTriggeringPolicy on: self temperature)
		whenMeets:
			(AndCompositeTriggeringCondition
				with: (DataStreamCurrentValueTriggeringCondition of: self temperature isGreaterThan: 11)
				with: (TimeIntervalTriggeringCondition checkingCurrentTimeIsBetween: (self eightPM to: self ninePM))).

	response := interface
		triggersFor:
			((ZnRequest get: 'http://COSMOS_URL/v1/triggers')
				setAccept: (ZnMimeType fromString: 'application/vnd.cosmos.trigger+json; version=1.0.0');
				yourself).
	self
		assert: response isSuccess;
		assert: response contents
			equals:
			('[
	{
		"name" : "Set triggered to true after data point regisration on Temperature",
		"created_on" : "2015-09-06T12:00:00-03:00",
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

	self triggerManagementSystem
		registerNamed: 'Set triggered to true periodically every 5 minutes'
		triggering: self setTriggedToTrue
		accordingTo: (PeriodicalTriggeringPolicy every: self fiveMinutes)
		whenMeets: AlwaysTriggeringCondition new.

	response := interface
		triggersFor:
			((ZnRequest get: 'http://COSMOS_URL/v1/triggers')
				setAccept: (ZnMimeType fromString: 'application/vnd.cosmos.trigger+json; version=1.0.0');
				yourself).

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
						type: (ZnMimeType fromString: 'application/vnd.cosmos.trigger+json; version=1.0.0'))).

	self
		assert: response code equals: 201;
		assert: response location equals: 'http://cosmos_url/v1/triggers'.

	self triggerManagementSystem
		triggerNamed: 'Set triggered to true on data point registration'
		ifFound: [ :trigger | 
			self
				assert: trigger name equals: 'Set triggered to true on data point registration';
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
						type: self triggerJsonVersion1dot0dot0MimeType)).
						
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
TriggersAPITest >> triggerJsonVersion1dot0dot0MimeType [

	^ ZnMimeType
		fromString: 'application/vnd.cosmos.trigger+json; version=1.0.0'
]

{ #category : #'expected results' }
TriggersAPITest >> triggersAsJSON [

	^ '[
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
]' expandMacrosWith: TimeZones local offset
]
