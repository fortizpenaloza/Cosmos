scheduling
do: aTask every: aTimePeriod

	scheduledTasks add: (ScheduledTask doing: aTask every: aTimePeriod)
	