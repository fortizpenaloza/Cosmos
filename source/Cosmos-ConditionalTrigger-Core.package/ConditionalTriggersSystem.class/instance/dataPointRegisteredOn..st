events handling
dataPointRegisteredOn: anEvent

	triggersToFireOnDataPointRegistration
		select: [:trigger | trigger key = anEvent dataStream]
		thenDo: [:trigger | trigger value fire]