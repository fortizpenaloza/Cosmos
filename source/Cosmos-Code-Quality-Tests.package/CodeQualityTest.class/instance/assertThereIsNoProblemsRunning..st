tests support
assertThereIsNoProblemsRunning: aRule

	| ruleCheckingResult |

	ruleCheckingResult := self checkingResultFor: aRule.
	self assert: ruleCheckingResult problemCount = 0 description: (self descriptionFrom: ruleCheckingResult)