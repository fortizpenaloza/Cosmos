as yet unclassified
test01

	| wasRun task scheduler |
	
	wasRun := false.
	task := Task named: 'Change wasRun value to true' do: [ wasRun := true ].
	
	scheduler := PeriodicalScheduler workingWith: DelayNullScheduler new.
	scheduler do: task every: self tenMinutes.
	self deny: wasRun.
	
	scheduler start.
	[ self assert: wasRun ] forkAt: Processor lowestPriority.