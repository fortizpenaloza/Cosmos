scheduling
schedule: aScheduledTask

	| process |
	process := [ | delay |
		delay := Delay forDuration: (self durationFrom: aScheduledTask timePeriod).
		delayScheduler schedule: delay.
		delay wait.
		aScheduledTask execute.
		self schedule: aScheduledTask ] newProcess.
	
	runningProcesses add: process.
	
	process
		name: aScheduledTask name;
		priority: Processor lowestPriority;
		resume.
	
	^ process