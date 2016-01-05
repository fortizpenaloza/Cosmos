as yet unclassified
testInstanceCreation

	| wasRun task |
	
	wasRun := false.
	task := Task named: 'Change boolean to true' do: [ wasRun := true ].
	
	self assert: task name equals: 'Change boolean to true'.
	
	self deny: wasRun.
	task execute.
	self assert: wasRun