managing
registerToTriggerOnDataPointRegistration: aConditionalTrigger on: aDataStream

	triggersToFireOnDataPointRegistration
		add: (Association key: aDataStream value: aConditionalTrigger)