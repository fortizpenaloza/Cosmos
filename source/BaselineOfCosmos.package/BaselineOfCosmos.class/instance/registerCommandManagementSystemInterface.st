actions
registerCommandManagementSystemInterface

	self
		registerInterfaceAs: #CommandManagementSystemInterface
		named: 'Command Management System Interface'
		declaring: #(#enqueue:with: #dequeue #prioritizedCommands)