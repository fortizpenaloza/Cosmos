system specification
implementedInterface

	^ SystemInterface
		named: 'Command Management System Interface'
		offering:
			(OrderedCollection new
				add: #registerCommandPriorityQueue;
				add: #push:with:toQueueIdentifiedBy:;
				add: #popFromQueueIdentifiedBy:;
				yourself)