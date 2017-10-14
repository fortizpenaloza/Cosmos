tests
testPushingCommand

	| interface prioritizedCommand |

	interface := RESTCommandsInterface workingWith: rootSystem.
	prioritizedCommand := interface push: '{
	"command" : "TURN_ON_LED",
	"priority" : "high"
}'.

	self assert: (self commandManagementSystem prioritizedCommands includes: prioritizedCommand)

	