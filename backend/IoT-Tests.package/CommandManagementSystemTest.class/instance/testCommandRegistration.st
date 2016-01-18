tests
testCommandRegistration

	| timeSource rootSystem commandManagementSystem nextCommand commandQueue |
	
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
	commandManagementSystem register: 'TURN_ON_LED' with: CommandPriority high new to: 1.
		
	commandQueue := commandManagementSystem commandQueueIdentifiedBy: 1.
	self deny: commandQueue isEmpty.
	
	nextCommand := commandManagementSystem nextCommandFromCommandQueueIdentifiedBy: 1.
	self assert: nextCommand equals: 'TURN_ON_LED'.
	self assert: commandQueue isEmpty.