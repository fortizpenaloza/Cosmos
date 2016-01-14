tests
testExecution

	| wasExecuted task scheduledTask |

	wasExecuted := false.
	task := Task named: 'Change boolean to true' do: [ wasExecuted := true ].
	scheduledTask := ScheduledTask executing: task every: self oneMinute.
	self deny: wasExecuted.
	
	scheduledTask execute.
	self assert: wasExecuted