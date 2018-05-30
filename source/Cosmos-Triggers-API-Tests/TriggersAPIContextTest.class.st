"
A TriggersAPIContextTest is a test class for testing the behavior of TriggersAPIContext
"
Class {
	#name : #TriggersAPIContextTest,
	#superclass : #SystemBasedUserStoryTest,
	#instVars : [
		'context'
	],
	#category : #'Cosmos-Triggers-API-Tests'
}

{ #category : #initialization }
TriggersAPIContextTest >> decemberTenthOf2016AtNoon [

	^ (December tenth , 2016) atNoon
]

{ #category : #accessing }
TriggersAPIContextTest >> fiveMinutes [
	
	^ TimeUnits minute with: 5
]

{ #category : #accessing }
TriggersAPIContextTest >> setTriggedToTrue [

	^ Action
		named: 'Set triggered to true'
		createdOn: self decemberTenthOf2016AtNoon
		toEvaluate: (BlockEvaluationPolicy for: [ "do nothing" ])
]

{ #category : #initialization }
TriggersAPIContextTest >> setUp [

	super setUp.

	context := (TriggersAPIContext workingWith: rootSystem).

	(SensorsSampleAddOn on: rootSystem) install.

	self actionManagementSystem
		registerNamed: 'Set triggered to true'
		toEvaluate: (BlockEvaluationPolicy for: [ "Do nothing" ])
]

{ #category : #initialization }
TriggersAPIContextTest >> setUpRequirements [

	super
		setUpRequirements;
		requireDataManagementSystem;
		requireActionManagementSystem;
		requireTriggerManagementSystem
]

{ #category : #accessing }
TriggersAPIContextTest >> temperature [
	
	^ DataStream named: 'Temperature' createdOn: self decemberTenthOf2016AtNoon 
]

{ #category : #accessing }
TriggersAPIContextTest >> testMappingSetTriggeredToTrueAfterDataPointWasRegisteredOnTemperature [

	| trigger json |

	trigger := ActionTrigger
		named: 'Set triggered to true after data point regisration on Temperature'
		createdOn: self decemberTenthOf2016AtNoon
		triggering: self setTriggedToTrue
		accordingTo: (DataPointRegistrationTriggeringPolicy on: self temperature)
		ifSatisfies: AlwaysTriggeringCondition new.

	json := context mapToJson: trigger.

	self
		assert: json
		equals:
			'{
	"name" : "Set triggered to true after data point regisration on Temperature",
	"created_on" : "2016-12-10T12:00:00-03:00",
	"action" : "Set triggered to true",
	"policy" : {
		"type" : "on_data_point_registration",
		"data_stream" : "Temperature"
	},
	"conditions" : [ ]
}'
]

{ #category : #accessing }
TriggersAPIContextTest >> testMappingSetTriggeredToTrueAfterDataPointWasRegisteredOnTemperatureAndItsLessThanEleven [

	| trigger json |

	trigger := ActionTrigger
		named: 'Set triggered to true after data point regisration on Temperature'
		createdOn: self decemberTenthOf2016AtNoon
		triggering: self setTriggedToTrue
		accordingTo: (DataPointRegistrationTriggeringPolicy on: self temperature)
		ifSatisfies: (DataStreamCurrentValueTriggeringCondition of: self temperature isLessThan: 11).

	json := context mapToJson: trigger.

	self
		assert: json
		equals:
			'{
	"name" : "Set triggered to true after data point regisration on Temperature",
	"created_on" : "2016-12-10T12:00:00-03:00",
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
				"operator" : "<",
				"value" : 11
			}
		}
	]
}'
]

{ #category : #accessing }
TriggersAPIContextTest >> testMappingSetTriggeredToTruePeriodicallyEveryFiveMinutes [

	| trigger json |

	trigger := ActionTrigger
		named: 'Set triggered to true periodically every 5 minutes'
		createdOn: self decemberTenthOf2016AtNoon
		triggering: self setTriggedToTrue
		accordingTo: (PeriodicalTriggeringPolicy every: self fiveMinutes)
		ifSatisfies: AlwaysTriggeringCondition new.

	json := context mapToJson: trigger.

	self
		assert: json
		equals:
			'{
	"name" : "Set triggered to true periodically every 5 minutes",
	"created_on" : "2016-12-10T12:00:00-03:00",
	"action" : "Set triggered to true",
	"policy" : {
		"type" : "periodical",
		"time_interval" : "5 minutes"
	},
	"conditions" : [ ]
}'
]
