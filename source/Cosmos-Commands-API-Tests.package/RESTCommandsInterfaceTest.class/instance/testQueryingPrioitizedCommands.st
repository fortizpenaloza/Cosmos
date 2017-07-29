tests
testQueryingPrioitizedCommands

	| interface response |

	interface := RESTCommandsInterface workingWith: rootSystem.
	response := interface prioritizedCommands.

	self assert: response equals: '[
	{
		"command" : "TURN_ON_LED",
		"priority" : "High"
	}
]'