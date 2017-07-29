tests
testQueryingNextCommandFormattedAsPlainText

	| interface response |

	interface := RESTCommandsInterface workingWith: rootSystem.
	response := interface nextCommandAsPlainText.

	self assert: response equals: 'TURN_ON_LED'