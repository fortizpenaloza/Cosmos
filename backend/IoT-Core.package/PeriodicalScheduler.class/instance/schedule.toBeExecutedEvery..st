configuring
schedule: aTask toBeExecutedEvery: aTimePeriod

	scheduledTasks add: (ScheduledTask executing: aTask every: aTimePeriod)
	