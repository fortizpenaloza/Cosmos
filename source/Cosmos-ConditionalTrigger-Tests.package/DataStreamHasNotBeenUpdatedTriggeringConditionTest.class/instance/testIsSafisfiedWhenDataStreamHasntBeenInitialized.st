tests
testIsSafisfiedWhenDataStreamHasntBeenInitialized

	| condition |

	condition := DataStreamHasNotBeenUpdatedTriggeringCondition
		querying: self
		toCheckIf:
			(DataStream
				named: 'Temperature'
				createdOn: self septemberSixthOf2014AtNoon)
		hasNotBeenUpdatedForMoreThan: (TimeUnits minute with: 10).

	self
		should: [ condition isSatisfied ]
		raise: AssertionFailed
		withDescription: 'Last update date and time has not been initialized.'