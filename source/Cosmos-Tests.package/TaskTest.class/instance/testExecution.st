tests
testExecution

	| wasExecuted task |
	
	wasExecuted := false.
	task := Task named: 'Change boolean to true' do: [ wasExecuted := true ].
	self deny: wasExecuted.
	
	task execute.
	self assert: wasExecuted