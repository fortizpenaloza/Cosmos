system specification
implementedInterface

	^ SystemInterface
		named: 'Conditional Triggers System Interface'
		offering:
			(OrderedCollection new
				add: #register:toTriggerOnDataPointRegistrationOn:;
				add: #register:triggerPeriodicallyEvery:;
				add: #havePassed:;
				add: #dataPointRegisteredOn:;
				yourself)