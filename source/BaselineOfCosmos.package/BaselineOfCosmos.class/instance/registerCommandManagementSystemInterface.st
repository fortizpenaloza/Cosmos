actions
registerCommandManagementSystemInterface

	self
		registerInterfaceAs: #CommandManagementSystemInterface
		named: 'Command Management System Interface'
		offering: #(#push:with: #pop #prioritizedCommands)