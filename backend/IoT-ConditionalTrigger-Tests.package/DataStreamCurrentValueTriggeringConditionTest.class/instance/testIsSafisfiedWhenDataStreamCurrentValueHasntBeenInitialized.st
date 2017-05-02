tests
testIsSafisfiedWhenDataStreamCurrentValueHasntBeenInitialized

	| condition |

	condition := DataStreamCurrentValueTriggeringCondition
		of: (DataStream named: 'Test' createdOn: self septemberSixthOf2015AtNoon belongingTo: self dataChannel)
		isLessThan: 10.

	self
		should: [ condition isSatisfied ]
		raise: ObjectIsUnbound
		withExceptionDo: [ :signal | self assert: signal messageText equals: 'Current value has not been initialized.' ]