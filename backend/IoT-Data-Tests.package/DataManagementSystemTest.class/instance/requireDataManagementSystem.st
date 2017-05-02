running
requireDataManagementSystem

	identifierProvider := FixedNumberProvider providing: self identifier.
	rootSystem := CompositeSystem empty.

	(OrderedCollection
		with: (TimeSystem using: (FixedTimeSource on: self septemberSixth2015AtNoon))
		with: (DataManagementSystem using: identifierProvider)
		with: EventNotificationSystem new) do: [ :subsystem | rootSystem register: subsystem ].

	rootSystem startUp