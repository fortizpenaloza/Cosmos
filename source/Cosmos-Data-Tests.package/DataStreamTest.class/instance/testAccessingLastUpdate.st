tests
testAccessingLastUpdate

	| dataStream dataPoint |

	dataStream := DataStream
		named: 'Temperature'
		createdOn: self septemberSixthOf2014AtNoon.

	self
		should: [ dataStream lastUpdate ]
		raise: AssertionFailed
		withDescription: 'Last update date and time has not been initialized.'.

	dataPoint := DataPoint
		on: self octoberFirstOf2014AtMidnight
		holding: 10.
	dataStream add: dataPoint.
	self assert: dataStream lastUpdate equals: dataPoint timestamp