running
setUp

	timeSource := FixedTimeSource on: September tenth , 2015 at: TimeOfDay noon.

	rootSystem := CompositeSystem empty.

	(OrderedCollection new)
		add: (TimeSystem using: timeSource);
		add: ConditionalTriggersSystem new;
		add: (DataManagementSystem using: SequentialNumberProvider new);
		add: EventNotificationSystem new;	
		do: [ :subsystem | rootSystem register: subsystem ].

	rootSystem startUp