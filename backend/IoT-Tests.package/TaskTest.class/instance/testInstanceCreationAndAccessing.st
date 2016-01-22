tests
testInstanceCreationAndAccessing

	| wasExecuted task |
	
	wasExecuted := false.
	task := Task named: 'Change boolean to true' do: [ wasExecuted := true ].
	
	self assert: task name equals: 'Change boolean to true'.
	self deny: wasExecuted