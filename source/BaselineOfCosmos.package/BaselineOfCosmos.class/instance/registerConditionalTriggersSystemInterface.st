actions
registerConditionalTriggersSystemInterface

	self
		registerInterfaceAs: #ConditionalTriggersSystemInterface
		named: 'Conditional Triggers System Interface'
		offering: #(#register:toTriggerOnDataPointRegistrationOn: #register:triggerPeriodicallyEvery: #havePassed: #dataPointRegisteredOn:)