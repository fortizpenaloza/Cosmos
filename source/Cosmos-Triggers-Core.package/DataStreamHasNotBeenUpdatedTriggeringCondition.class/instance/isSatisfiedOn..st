testing
isSatisfiedOn: aContext

	^ (dataStream lastUpdate distanceTo: aContext dateTime) > timePeriod 