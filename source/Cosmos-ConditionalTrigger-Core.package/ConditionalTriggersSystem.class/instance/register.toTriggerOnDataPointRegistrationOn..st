managing
register: aConditionalTrigger toTriggerOnDataPointRegistrationOn: aDataStream

	triggersToFireOnDataPointRegistration
		add: (Association key: aDataStream value: aConditionalTrigger)