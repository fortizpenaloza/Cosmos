notifying
notifyHavePassed: aTimePeriod

	triggersToFirePeriodically
		select: [:trigger | trigger key = aTimePeriod]
		thenDo: [:trigger | trigger value fire]