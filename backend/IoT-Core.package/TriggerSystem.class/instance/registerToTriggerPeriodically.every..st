managing
registerToTriggerPeriodically: aConditionalTrigger every: aTimePeriod

	triggersToFirePeriodically add: (Association key: aTimePeriod value: aConditionalTrigger)
