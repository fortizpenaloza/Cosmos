tests
testRegistrationOfPeriodicalTrigger

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