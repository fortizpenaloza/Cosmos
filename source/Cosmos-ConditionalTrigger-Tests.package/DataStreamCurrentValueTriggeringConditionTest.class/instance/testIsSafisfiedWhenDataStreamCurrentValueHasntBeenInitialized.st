tests
testIsSafisfiedWhenDataStreamCurrentValueHasntBeenInitialized

	| condition |

	condition := DataStreamCurrentValueTriggeringCondition
		of: (DataStream named: 'Test' createdOn: self septemberSixthOf2014AtNoon)
		isLessThan: 10.

	self
		should: [ (condition isSatisfiedOn: self) ]
		raise: BindingNotYetDefined 
		withDescription: 'Current value has not been initialized.'