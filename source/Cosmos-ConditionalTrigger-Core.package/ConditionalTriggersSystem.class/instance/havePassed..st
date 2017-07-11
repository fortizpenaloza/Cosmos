events handling
havePassed: aTimePeriod

	triggersToFirePeriodically
		select: [:trigger | trigger key = aTimePeriod]
		thenDo: [:trigger | trigger value fire]