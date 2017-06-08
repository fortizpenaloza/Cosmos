running
setUp

	timeSource := FixedTimeSource
		on: September tenth , 2015
		at: TimeOfDay noon.

	rootSystem := CompositeSystem
		of:
			(OrderedCollection new
				add: (TimeSystem using: timeSource);
				add: ConditionalTriggersSystem new;
				add: (DataManagementSystem using: SequentialNumberProvider new);
				add: EventNotificationSystem new;
				yourself).

	rootSystem startUp