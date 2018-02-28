tests
testQueryingTriggers

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