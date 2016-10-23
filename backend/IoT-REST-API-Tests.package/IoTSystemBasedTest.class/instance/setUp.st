running
setUp

	timeSource := FixedTimeSource on: self septemberSixth2015AtNoon.
	identifierProvider := FixedNumberProvider providing: self identifier.
	rootSystem := CompositeSystem empty.

	(OrderedCollection
		with: (TimeSystem using: timeSource)
		with: (DataManagementSystem using: identifierProvider)
		with: ConditionalTriggersSystem new) do: [ :subsystem | rootSystem register: subsystem ].

	rootSystem startUp.

	self addSensorsSampleData.
		