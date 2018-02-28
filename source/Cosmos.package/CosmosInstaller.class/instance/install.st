installing
install

	| cosmos scheduler task |

	cosmos := self buildSystem.
	cosmos startUp.

	self installAPIsOn: cosmos.

	task := Task
		named: 'Notify 10 seconds has passed'
		do: [ (cosmos systemImplementing: #EventNotificationSystemInterface)
				notifySubscribersTo: (TickEvent of: (TimeUnits second with: 10)) ].

	scheduler := PeriodicalScheduler workingWith: DelayExperimentalSemaphoreScheduler new.
	scheduler schedule: task toBeExecutedEvery: (TimeUnits second with: 10).

	scheduler start.
	
	^ cosmos