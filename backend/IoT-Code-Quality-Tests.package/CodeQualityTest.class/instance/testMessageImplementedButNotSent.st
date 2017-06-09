tests
testMessageImplementedButNotSent

	| ruleCheckingResult |

	ruleCheckingResult := self runRule: RBImplementedNotSentRule new.
	self
		assert: ruleCheckingResult problemCount = 0
		description: (self descriptionFrom: ruleCheckingResult)