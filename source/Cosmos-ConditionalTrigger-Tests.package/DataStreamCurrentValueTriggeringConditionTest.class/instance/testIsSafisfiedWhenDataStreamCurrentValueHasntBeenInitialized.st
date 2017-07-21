tests
testIsSafisfiedWhenDataStreamCurrentValueHasntBeenInitialized

	| condition |

	condition := DataStreamCurrentValueTriggeringCondition
		of: (DataStream named: 'Test' createdOn: self septemberSixthOf2014AtNoon)
		isLessThan: 10.

	self
		should: [ condition isSatisfied ]
		raise: AssertionFailed
		withDescription: 'Current value has not been initialized.'