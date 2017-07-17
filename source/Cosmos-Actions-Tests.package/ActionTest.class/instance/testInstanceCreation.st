tests
testInstanceCreation

	| action |

	action := Action
		named: 'Send YO'
		createdOn: self septemberSixth2015AtTwelveOFivePM
		toEvaluate: (BlockEvaluationPolicy for: [ "do nothing" ]).

	self
		assert: action name equals: 'Send YO';
		assert: action creationDateTime equals: self septemberSixth2015AtTwelveOFivePM