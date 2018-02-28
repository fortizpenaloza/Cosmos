tests
testRegistrationOfDataPointRegistered

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