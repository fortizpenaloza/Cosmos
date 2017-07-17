tests
testQueringRegisteredActions

	| action |

	action := self actionManagementSystem
		registerNamed: 'Send YO to Fran'
		toEvaluate: [ "empty" ].

	self
		assert: self actionManagementSystem actions
		hasTheSameElementsInTheSameOrderThat: {action}.

	self actionManagementSystem unregisterNamed: 'Send YO to Fran'.

	self assert: self actionManagementSystem actions isEmpty