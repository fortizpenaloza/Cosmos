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

	interface := TriggersAPI workingWith: (TriggersAPIContext workingWith: rootSystem).

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
	"name" : "Always set triggered to true",
	"action" : "Set triggered to true",
	"policy" : {
		"type" : "periodical",
		"time_interval" : "5 minutes"
	},
	"condition" : "true"
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
		triggerNamed: 'Always set triggered to true'
		ifFound: [ :trigger | self fail ]
		ifNone: [ "do nothing" ].

	response := interface
		registerFrom:
			'{
	"name" : "Always set triggered to true",
	"action" : "Set triggered to true",
	"policy" : {
		"type" : "data_point_registration",
		"data_stream" : "Temperature"
	},
	"condition" : "true"
}'.

	self assert: response code equals: 201.

	self triggerManagementSystem
		triggerNamed: 'Always set triggered to true'
		ifFound: [ :trigger | 
			self
				assert: trigger name equals: 'Always set triggered to true';
				assert: trigger creationDateTime equals: self timeSystem dateTime ]
		ifNone: [ self fail ]
]

{ #category : #tests }
TriggersAPITest >> testRegistrationOfPeriodicalTrigger [

	self triggerManagementSystem
		triggerNamed: 'Always set triggered to true'
		ifFound: [ :trigger | self fail ]
		ifNone: [ "do nothing" ].

	interface
		registerFrom:
			'{
	"name" : "Always set triggered to true",
	"action" : "Set triggered to true",
	"policy" : {
		"type" : "periodical",
		"time_interval" : "00:05:00"
	},
	"condition" : "true"
}'.

	self triggerManagementSystem
		triggerNamed: 'Always set triggered to true'
		ifFound: [ :trigger | 
			self
				assert: trigger name equals: 'Always set triggered to true';
				assert: trigger creationDateTime equals: self timeSystem dateTime ]
		ifNone: [ self fail ]
]

{ #category : #'expected results' }
TriggersAPITest >> triggersAsJSON [

	^ '[
	{
		"name" : "Always set triggered to true",
		"created_on" : "2015-09-06T12:00:00<1p>",
		"policy" : {
			"type" : "periodical",
			"time_interval" : "5 minutes"
		},
		"action" : "Set triggered to true",
		"condition" : "true"
	}
]' expandMacrosWith: TimeZones local offset
]
