test
testIsSafisfiedWhenDataStreamHasntBeenInitialized

	| condition |

	condition := DataStreamHasNotBeenUpdatedTriggerCondition
		querying: self
		toCheckIf: (DataStream identifiedBy: 'test')
		hasNotBeenUpdatedForMoreThan: (TimeUnits minute with: 10).
		
	self
		should: [ condition isSatisfied ]
		raise: ObjectIsUnbound
		withExceptionDo: [ :signal | self assert: signal messageText equals: 'Last update date and time has not been initialized.' ]