running
setUp

	| timeSource |
	
	timeSource := FixedTimeSource
		on: September tenth , 2014
		at: TimeOfDay noon.
	
	identifierProvider := FixedNumberProvider providing: 1.

	rootSystem := CompositeSystem named: 'IoT for testing'.

	(OrderedCollection
		with: (TimeSystem using: timeSource)
		with: (DataManagementSystem using: identifierProvider)
		with: ConditionalTriggerManagementSystem new)
		do: [ :subsystem | rootSystem register: subsystem ].
	
	rootSystem startUp
