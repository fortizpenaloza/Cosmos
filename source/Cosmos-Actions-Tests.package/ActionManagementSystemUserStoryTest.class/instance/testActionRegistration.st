tests
testActionRegistration

	| action |

	action := self actionManagementSystem
		registerNamed: 'Send YO to Fran'
		toEvaluate: [ "empty" ].

	self
		assert: action name equals: 'Send YO to Fran';
		assert: action creationDateTime equals: self septemberSixth2015AtNoon