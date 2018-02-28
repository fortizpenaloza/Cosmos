tests
testInstanceCreation

	| action |

	action := Action
		named: 'Do nothing'
		createdOn: self septemberSixth2015AtTwelveOFivePM
		toEvaluate: (BlockEvaluationPolicy for: [ "do nothing" ]).

	self
		assert: action name equals: 'Do nothing';
		assert: action creationDateTime equals: self septemberSixth2015AtTwelveOFivePM