notifying
notifyDataPointRegistrationOn: aDataStream of: aFeed

	triggersToFireOnDataPointRegistration
		select: [:trigger | trigger key = aDataStream]
		thenDo: [:trigger | trigger value fire]