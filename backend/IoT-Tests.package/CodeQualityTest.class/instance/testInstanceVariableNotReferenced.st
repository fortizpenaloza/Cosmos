tests
testInstanceVariableNotReferenced

	| ruleCheckingResult |

	ruleCheckingResult := self runRule: RBUnreferencedVariablesRule new.
	self
		assert: ruleCheckingResult problemCount  = 0
		description:
			('<1s> (<2p>): <3s>'
				expandMacrosWith: ruleCheckingResult label
				with: ruleCheckingResult problemCount 
				with: ruleCheckingResult instanceVariables asString)