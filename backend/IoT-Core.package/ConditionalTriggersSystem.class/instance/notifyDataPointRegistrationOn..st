notifying
notifyDataPointRegistrationOn: aDataStream

	triggersToFireOnDataPointRegistration
		select: [:trigger | trigger key = aDataStream]
		thenDo: [:trigger | trigger value fire]