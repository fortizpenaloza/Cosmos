actions
defineCommandManagementSystemInterface

	Smalltalk
		at: #CommandManagementSystemInterface
		put:
			(SystemInterface
				named: 'Command Management System Interface'
				offering: #(#registerCommandPriorityQueue #push:with:toQueueIdentifiedBy: #popFromQueueIdentifiedBy:))