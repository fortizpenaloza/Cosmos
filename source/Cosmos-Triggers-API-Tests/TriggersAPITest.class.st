Class {
	#name : #TriggersAPITest,
	#superclass : #SystemBasedUserStoryTest,
	#instVars : [
		'interface'
	],
	#category : 'Cosmos-Triggers-API-Tests'
}

{ #category : #accessing }
TriggersAPITest >> alwaysCondition [

	^ AlwaysTriggeringCondition new
]

{ #category : #accessing }
TriggersAPITest >> fiveMinutes [

	^ TimeUnits minute with: 5
]

{ #category : #accessing }
TriggersAPITest >> septemberSixth2015AtTwelveOFivePM [

	^ (September sixth , 2015) atNoon next: self fiveMinutes
]

{ #category : #initialization }
TriggersAPITest >> setUp [

	| setTriggeredToTrue |

	super setUp.

	interface := TriggersAPI workingWithin: (TriggersAPIContext workingWith: rootSystem).

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
TriggersAPITest >> tenMinutes [

	^ TimeUnits minute with: 10
]

{ #category : #tests }
TriggersAPITest >> testQueryingTriggers [

	| response |

	interface
		registerFrom:
			'{
	"name" : "Set triggered to true periodically every 5 minutes",
	"action" : "Set triggered to true",
	"policy" : {
		"type" : "periodical",
		"time_interval" : "5 minutes"
	},
	"conditions" : [ ]
}'.

	response := interface triggers.

	self
		assert: response code equals: 200;
		assert: response contents equals: self triggersAsJSON
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
			'{
	"name" : "Set triggered to true on data point registration",
	"action" : "Set triggered to true",
	"policy" : {
		"type" : "data_point_registration",
		"data_stream" : "Temperature"
	},
	"conditions" : [ ]
}'.

	self assert: response code equals: 201.

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

	self triggerManagementSystem
		triggerNamed: 'Set triggered to true periodically every 5 minutes'
		ifFound: [ :trigger | self fail ]
		ifNone: [ "do nothing" ].

	interface
		registerFrom:
			'{
	"name" : "Set triggered to true periodically every 5 minutes",
	"action" : "Set triggered to true",
	"policy" : {
		"type" : "periodical",
		"time_interval" : "00:05:00"
	},
	"conditions" : [ ]
}'.

	self triggerManagementSystem
		triggerNamed: 'Set triggered to true periodically every 5 minutes'
		ifFound: [ :trigger | 
			self
				assert: trigger name equals: 'Set triggered to true periodically every 5 minutes';
				assert: trigger creationDateTime equals: self timeSystem dateTime ]
		ifNone: [ self fail ]
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
