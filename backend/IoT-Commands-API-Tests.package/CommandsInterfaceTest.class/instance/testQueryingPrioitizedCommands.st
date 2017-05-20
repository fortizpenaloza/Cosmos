tests
testQueryingPrioitizedCommands

	| interface response |

	interface := CommandsInterface workingWith: rootSystem.
	response := interface prioritizedCommandsFromQueueIdentifiedBy: self identifier.

	self assert: response equals: '[
	{
		"command" : "TURN_ON_LED",
		"priority" : "High"
	}
]'