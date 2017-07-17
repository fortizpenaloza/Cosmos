managing
registerNamed: aName toEvaluate: aEvaluationPolicy

	| action |

	action := Action
		named: aName
		createdOn: timeSystem dateTime
		toEvaluate: aEvaluationPolicy.

	self register: action.

	^ action