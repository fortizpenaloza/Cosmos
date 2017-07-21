tests
testInstanceCreationAndAccessing

	| dataStream |

	dataStream := DataStream
		named: 'Temperature'
		createdOn: self octoberFirstOf2014AtMidnight.

	self
		assert: dataStream name equals: 'Temperature';
		assert: dataStream creationDateTime
			equals: self octoberFirstOf2014AtMidnight;
		assert: dataStream dataPoints isEmpty