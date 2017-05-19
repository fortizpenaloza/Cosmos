running
setUp

	timeSource := FixedTimeSource on: self septemberSixth2015AtNoon.
	identifierProvider := FixedNumberProvider providing: self identifier.
	rootSystem := CompositeSystem empty.

	(OrderedCollection new)
		add: (TimeSystem using: timeSource);
		add: EventNotificationSystem new;
		add: (DataManagementSystem using: identifierProvider);
		add: ConditionalTriggersSystem new;
		add: (CommandManagementSystem using: identifierProvider);
		do: [ :subsystem | rootSystem register: subsystem ].

	rootSystem startUp.

	self addSensorsSampleData.
	self addHighPriorityCommand