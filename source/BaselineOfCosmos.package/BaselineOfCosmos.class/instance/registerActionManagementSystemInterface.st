actions
registerActionManagementSystemInterface

	self
		registerInterfaceAs: #ActionManagementSystemInterface
		named: 'Action Management System Interface'
		offering: #(#registerNamed:toEvaluate: #evaluateNamed: #deregisterNamed: actions)