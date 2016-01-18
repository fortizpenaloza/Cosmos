tests
testCommandQueueRegistration

	| timeSource rootSystem commandManagementSystem commandQueue |
	
	timeSource := FixedTimeSource
		on: September tenth , 2014
		at: TimeOfDay noon.
	
	commandManagementSystem := CommandManagementSystem using: (FixedNumberProvider providing: 1).
	
	rootSystem := CompositeSystem named: 'IoT for testing'.	
	(OrderedCollection
		with: (TimeSystem using: timeSource)
		with: commandManagementSystem) do: [ :subsystem | rootSystem register: subsystem ].
	rootSystem startUp.

	commandManagementSystem registerCommandQueueNamed: 'Commands queue for testing porpouses'.	

	commandQueue := commandManagementSystem commandQueueIdentifiedBy: 1.
	self assert: commandQueue isEmpty.
	self assert: commandQueue name equals: 'Commands queue for testing porpouses'.
	self assert: commandQueue identifier equals: 1