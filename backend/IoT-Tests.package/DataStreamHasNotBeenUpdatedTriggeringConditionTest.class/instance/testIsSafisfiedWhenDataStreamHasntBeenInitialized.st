test
testIsSafisfiedWhenDataStreamHasntBeenInitialized

	| condition |

	condition := DataStreamHasNotBeenUpdatedTriggeringCondition
		querying: self
		toCheckIf: (DataStream named: 'Test' createdOn: self septemberSixthOf2015AtNoon belongingTo: self dataChannel)
		hasNotBeenUpdatedForMoreThan: (TimeUnits minute with: 10).
		
	self
		should: [ condition isSatisfied ]
		raise: ObjectIsUnbound
		withExceptionDo: [ :signal | self assert: signal messageText equals: 'Last update date and time has not been initialized.' ]