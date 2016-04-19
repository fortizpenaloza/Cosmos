system specification
implementedInterface

	^ Interface
		named: 'Command Management System Interface'
		offering:
			(OrderedCollection new
				add: #registerCommandPriorityQueue;
				add: #push:with:toPriorityQueueIdentifiedBy:;
				add: #popFromQueueIdentifiedBy:;
				yourself)