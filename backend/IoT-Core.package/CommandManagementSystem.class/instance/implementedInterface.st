system specification
implementedInterface

	^ Interface
		named: 'Command Management System Interface'
		offering:
			(OrderedCollection new
				add: #registerCommandQueueNamed:
				add: #register:with:do:;
				add: #nextCommandFromCommandQueueIdentifiedBy:;
				yourself)