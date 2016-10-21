running
setUp

	timeSource := FixedTimeSource
		on: September tenth , 2015
		at: TimeOfDay noon.

	rootSystem := CompositeSystem empty.

	(OrderedCollection
		with: (TimeSystem using: timeSource)
		with: ConditionalTriggersSystem new
		with: (DataManagementSystem using: SequentialNumberProvider new))
		do: [ :subsystem | rootSystem register: subsystem ].
	
	rootSystem startUp