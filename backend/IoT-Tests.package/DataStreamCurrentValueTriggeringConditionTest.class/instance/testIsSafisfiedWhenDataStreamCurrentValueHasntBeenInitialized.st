test
testIsSafisfiedWhenDataStreamCurrentValueHasntBeenInitialized

	| condition |

	condition := DataStreamCurrentValueTriggeringCondition of: (DataStream identifiedBy: 'test') isLessThan: 10.
	
	self should: [ condition isSatisfied ] raise: ObjectIsUnbound withExceptionDo: [ :signal | self assert: signal messageText equals: 'Current value has not been initialized.' ]
	
	