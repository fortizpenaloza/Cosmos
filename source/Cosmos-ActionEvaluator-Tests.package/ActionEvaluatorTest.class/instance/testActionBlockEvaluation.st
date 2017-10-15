tests
testActionBlockEvaluation

	| evaluated |
	
	evaluated := false.
	self deny: evaluated.
	
	ActionEvaluator new
		evaluate:
			(Action
				named: 'Send YO to Fran'
				createdOn: (October first , 2014) atNoon
				toEvaluate: (BlockEvaluationPolicy for: [ evaluated := true ])).
	
	self assert: evaluated