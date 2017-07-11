accessing
turnOnLedWithLowPriority

	^ PrioritizedCommand
		holding: self turnOnLedCommand
		with: QueuePriority low
		on: (July twentyfourth , 2015) atMidnight