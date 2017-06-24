accessing
turnOffLedWithHighPriority

	^ PrioritizedCommand
		holding: self turnOffLedCommand
		with: QueuePriority high
		on: (July twentyfourth , 2015) atMidnight