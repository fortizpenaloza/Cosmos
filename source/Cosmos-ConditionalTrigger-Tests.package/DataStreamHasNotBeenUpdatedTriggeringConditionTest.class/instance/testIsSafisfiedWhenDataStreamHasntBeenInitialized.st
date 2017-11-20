tests
testIsSafisfiedWhenDataStreamHasntBeenInitialized

	| condition |

	condition := DataStreamHasNotBeenUpdatedTriggeringCondition
		checkingIf:
			(DataStream
				named: 'Temperature'
				createdOn: self septemberSixthOf2014AtNoon)
		hasNotBeenUpdatedForMoreThan: (TimeUnits minute with: 10).

	self
		should: [ (condition isSatisfiedOn: self) ]
		raise: AssertionFailed
		withDescription: 'Last update date and time has not been initialized.'