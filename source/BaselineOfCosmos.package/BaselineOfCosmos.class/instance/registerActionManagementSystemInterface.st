actions
registerActionManagementSystemInterface

	self
		registerInterfaceAs: #ActionManagementSystemInterface
		named: 'Action Management System Interface'
		declaring: #(#registerNamed:toEvaluate: #deregisterNamed: actions)