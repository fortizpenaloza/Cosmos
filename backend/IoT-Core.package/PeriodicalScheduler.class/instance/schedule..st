starting
schedule: aScheduledTask

	[ | delay |
		delay := Delay forDuration: (self durationFrom: aScheduledTask timePeriod).
		delayScheduler schedule: delay.
		delay wait.
		aScheduledTask execute.
		self schedule: aScheduledTask 
	] forkAt: Processor lowestPriority named: aScheduledTask name