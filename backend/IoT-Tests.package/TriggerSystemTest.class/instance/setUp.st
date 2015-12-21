running
setUp

	rootSystem := IoTSystem new.
	timeSource := FixedTimeSource on: September tenth , 2014 at: TimeOfDay noon.
	TimeSystem subsystemOf: rootSystem using: timeSource.
	TriggerSystem subsystemOf: rootSystem.
	FeedSystem subsystemOf: rootSystem.

	
	