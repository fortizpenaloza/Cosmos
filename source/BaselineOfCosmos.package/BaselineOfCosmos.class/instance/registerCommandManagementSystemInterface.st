actions
registerCommandManagementSystemInterface

	self
		registerInterfaceAs: #CommandManagementSystemInterface
		named: 'Command Management System Interface'
		offering: #(#enqueue:with: #pop #prioritizedCommands)