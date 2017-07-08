tests
testSubclassReponsibilityImplementedInLeafClases

	| ruleCheckingResult |

	ruleCheckingResult := self runRule: RBSubclassResponsibilityNotDefinedRule new.
	self
		assert: ruleCheckingResult problemCount = 0
		description: (self descriptionFrom: ruleCheckingResult)