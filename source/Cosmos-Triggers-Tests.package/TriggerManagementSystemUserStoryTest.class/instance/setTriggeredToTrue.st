accessing
setTriggeredToTrue

	^ Action
		named: 'Set triggered to true'
		createdOn: self septemberSixth2015AtTwelveOFivePM
		toEvaluate: (BlockEvaluationPolicy for: [ triggered := true ])