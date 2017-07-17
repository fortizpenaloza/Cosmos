actions
defineActionManagementSystemInterface

	Smalltalk
		at: #ActionManagementSystemInterface
		put:
			(SystemInterface
				named: 'Action Management System Interface'
				offering: #(#registerNamed:toEvaluate: #evaluateNamed: #unregisterNamed:))