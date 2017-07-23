tests
testQueringRegisteredActions

	| action anotherAction |

	action := self actionManagementSystem
		registerNamed: 'Send YO to Fran'
		toEvaluate: [ "empty" ].

	anotherAction := self actionManagementSystem
		registerNamed: 'Send text message to Fran'
		toEvaluate: [ "empty" ].

	self
		assert: self actionManagementSystem actions
		hasTheSameElementsInTheSameOrderThat: {action. anotherAction }.
