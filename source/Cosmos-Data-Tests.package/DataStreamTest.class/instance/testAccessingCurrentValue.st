tests
testAccessingCurrentValue

	| dataStream dataPoint |

	dataStream := DataStream
		named: 'Temperature'
		createdOn: self septemberSixthOf2014AtNoon.

	self
		should: [ dataStream currentValue ]
		raise: AssertionFailed
		withDescription: 'Current value has not been initialized.'.

	dataPoint := DataPoint
		on: self octoberFirstOf2014AtMidnight
		holding: 10.
	dataStream add: dataPoint.
	self assert: dataStream currentValue equals: 10