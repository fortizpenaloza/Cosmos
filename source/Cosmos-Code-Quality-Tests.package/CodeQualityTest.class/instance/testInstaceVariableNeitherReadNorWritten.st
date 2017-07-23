tests
testInstaceVariableNeitherReadNorWritten

	| ruleCheckingResult |

	ruleCheckingResult := self runRule: RBOnlyReadOrWrittenVariableRule new.
	self
		assert: ruleCheckingResult problemCount = 0
		description: (self descriptionFrom: ruleCheckingResult)