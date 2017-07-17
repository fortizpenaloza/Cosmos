tests
testActionEvaluation

	| evaluator evaluated |

	evaluator := ActionEvaluator new.

	evaluated := false.
	self deny: evaluated.

	evaluator
		evaluate:
			(Action
				named: 'Send YO to Fran'
				createdOn: (October first , 2014) atNoon
				toEvaluate: (BlockEvaluationPolicy for: [ evaluated := true ])).
	self assert: evaluated