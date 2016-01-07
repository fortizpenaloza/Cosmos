initialize-release
initializeWorkingWith: aDelayScheduler 

	delayScheduler := aDelayScheduler.
	scheduledTasks := OrderedCollection new.
	runningProcesses := WeakSet new.