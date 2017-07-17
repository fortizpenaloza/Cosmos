tests
testActionRegistrationFailsIfAlreadyExists

	| action |

	action := self actionManagementSystem
		registerNamed: 'Send YO to Fran'
		toEvaluate: [ "empty" ].

	self
		should: [ action := self actionManagementSystem
				registerNamed: 'Send YO to Fran'
				toEvaluate: [ "empty" ] ]
		raise: ObjectAlreadyInSystem
		withDescription: 'Action already exists in system'