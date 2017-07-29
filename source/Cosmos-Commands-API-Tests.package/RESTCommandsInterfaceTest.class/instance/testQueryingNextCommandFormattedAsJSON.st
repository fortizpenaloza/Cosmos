tests
testQueryingNextCommandFormattedAsJSON

	| interface response |

	interface := RESTCommandsInterface workingWith: rootSystem.
	response := interface nextCommandAsJSON.

	self assert: response equals: '{
	"command" : "TURN_ON_LED",
	"priority" : "High"
}'