system specification
implementedInterface

	^ Interface
		named: 'Command Management System Interface'
		offering:
			(OrderedCollection new
				add: #registerCommandPriorityQueue;
				add: #register:with:toQueueIdentifiedBy:;
				add: #nextCommandFromCommandQueueIdentifiedBy:;
				yourself)