accessing
turnOnMotorWithMediumPriority

	^ PrioritizedCommand
		holding: self turnOnMotorCommand
		with: QueuePriority medium
		on: (July twentyfourth , 2015) atMidnight