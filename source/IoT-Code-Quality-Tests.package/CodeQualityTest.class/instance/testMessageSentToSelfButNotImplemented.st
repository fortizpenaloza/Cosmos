tests
testMessageSentToSelfButNotImplemented

	| ruleCheckingResult |

	ruleCheckingResult := self runRule: RBSelfSentNotImplementedRule new.
	self
		assert: ruleCheckingResult problemCount = 0
		description: (self descriptionFrom: ruleCheckingResult)