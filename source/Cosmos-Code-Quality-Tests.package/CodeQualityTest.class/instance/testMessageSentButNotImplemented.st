tests
testMessageSentButNotImplemented

	| ruleCheckingResult |

	ruleCheckingResult := self runRule: RBSentNotImplementedRule new.
	self
		assert: ruleCheckingResult problemCount = 0
		description: (self descriptionFrom: ruleCheckingResult)