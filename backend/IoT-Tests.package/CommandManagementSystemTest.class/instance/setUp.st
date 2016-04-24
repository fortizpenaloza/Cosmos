running
setUp

	| timeSource |
	
	timeSource := FixedTimeSource
		on: September tenth , 2015
		at: TimeOfDay noon.
		
	identifierProvider := FixedNumberProvider providing: 1.

	rootSystem := CompositeSystem named: 'IoT for testing'.

	(OrderedCollection
		with: (TimeSystem using: timeSource)
		with: (CommandManagementSystem using: identifierProvider))
		do: [ :subsystem | rootSystem register: subsystem ].
	
	rootSystem startUp
