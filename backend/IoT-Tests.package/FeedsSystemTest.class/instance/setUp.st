running
setUp

	| timeSource |

	rootSystem := IoTSystem new.
	timeSource := FixedTimeSource on: September tenth , 2014 at: TimeOfDay noon.
	TimeSystem subsystemOf: rootSystem using: timeSource.
	ConditionalTriggersSystem subsystemOf: rootSystem.
	FeedsSystem subsystemOf: rootSystem.
