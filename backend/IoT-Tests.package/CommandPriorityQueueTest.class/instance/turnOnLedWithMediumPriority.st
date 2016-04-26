accessing
turnOnLedWithMediumPriority

	^ PrioritizedCommand
		holding: self turnOnLedCommand
		with: QueuePriority medium
		on: (July twentyfourth , 2015) atMidnight