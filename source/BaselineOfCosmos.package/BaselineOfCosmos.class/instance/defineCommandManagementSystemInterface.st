actions
defineCommandManagementSystemInterface

	Smalltalk
		at: #CommandManagementSystemInterface
		put:
			(SystemInterface
				named: 'Command Management System Interface'
				offering: #(#push:with: #pop #prioritizedCommands))