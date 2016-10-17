tests
testMessagesMustBeCategorized
 
	| ruleCheckingResult |

	ruleCheckingResult := self runRule: RBUnclassifiedMethodsRule new.
	self
		assert: ruleCheckingResult problemCount = 0
		description: (self descriptionFrom: ruleCheckingResult)