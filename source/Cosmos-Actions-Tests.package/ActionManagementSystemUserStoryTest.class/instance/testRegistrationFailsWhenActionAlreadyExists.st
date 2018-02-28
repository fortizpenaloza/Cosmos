tests
testRegistrationFailsWhenActionAlreadyExists

	| action |

	action := self actionManagementSystem
		registerNamed: 'Send YO to Fran'
		toEvaluate: [ "empty" ].

	self
		should: [ action := self actionManagementSystem
				registerNamed: 'Send YO to Fran'
				toEvaluate: [ "empty" ] ]
		raise: ObjectAlreadyInSystem
		withDescription: 'An action with that name already exists in system'