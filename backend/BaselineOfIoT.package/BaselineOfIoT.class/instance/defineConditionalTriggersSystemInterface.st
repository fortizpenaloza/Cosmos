actions
defineConditionalTriggersSystemInterface

	Smalltalk
		at: #ConditionalTriggersSystemInterface
		put:
			(SystemInterface
				named: 'Conditional Triggers System Interface'
				offering:
					#(#register:toTriggerOnDataPointRegistrationOn: #register:triggerPeriodicallyEvery: #havePassed: #dataPointRegisteredOn:))