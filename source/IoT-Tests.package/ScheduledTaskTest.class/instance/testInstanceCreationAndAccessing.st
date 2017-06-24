tests
testInstanceCreationAndAccessing

	| wasExecuted task scheduledTask |

	wasExecuted := false.
	task := Task named: 'Change boolean to true' do: [ wasExecuted := true ].
	scheduledTask := ScheduledTask executing: task every: self oneMinute.

	self
		assert: scheduledTask name equals: 'Change boolean to true';
		assert: scheduledTask timePeriod equals: self oneMinute;
		deny: wasExecuted