Class {
	#name : #DataStreamTest,
	#superclass : #TestCase,
	#category : 'Cosmos-Data-Tests-Model'
}

{ #category : #accessing }
DataStreamTest >> octoberFirstOf2014AtMidnight [

	^ (October tenth, 2014) atMidnight
]

{ #category : #accessing }
DataStreamTest >> septemberSixthOf2014AtNoon [

	^ (September sixth , 2014) atNoon
]

{ #category : #tests }
DataStreamTest >> testAccessingCurrentValue [

	| dataStream dataPoint |

	dataStream := DataStream
		named: 'Temperature'
		createdOn: self septemberSixthOf2014AtNoon.

	self
		should: [ dataStream currentValue ]
		raise: BindingNotYetDefined
		withDescription: 'Current value has not been initialized.'.

	dataPoint := DataPoint
		on: self octoberFirstOf2014AtMidnight
		holding: 10.
	dataStream add: dataPoint.
	self assert: dataStream currentValue equals: 10
]

{ #category : #tests }
DataStreamTest >> testAccessingLastUpdate [

	| dataStream dataPoint |

	dataStream := DataStream
		named: 'Temperature'
		createdOn: self septemberSixthOf2014AtNoon.

	self
		should: [ dataStream lastUpdate ]
		raise: BindingNotYetDefined
		withDescription: 'Last update date and time has not been initialized.'.

	dataPoint := DataPoint
		on: self octoberFirstOf2014AtMidnight
		holding: 10.
	dataStream add: dataPoint.
	self assert: dataStream lastUpdate equals: dataPoint timestamp
]

{ #category : #tests }
DataStreamTest >> testAddingDataPoint [

	| dataStream |

	dataStream := DataStream
		named: 'Temperature'
		createdOn: self septemberSixthOf2014AtNoon.

	self assert: dataStream dataPoints isEmpty.

	dataStream
		add: (DataPoint on: self octoberFirstOf2014AtMidnight holding: 10).
	self
		deny: dataStream dataPoints isEmpty;
		assert: dataStream dataPoints size equals: 1
]

{ #category : #tests }
DataStreamTest >> testInstanceCreationAndAccessing [

	| dataStream |

	dataStream := DataStream
		named: 'Temperature'
		createdOn: self octoberFirstOf2014AtMidnight.

	self
		assert: dataStream name equals: 'Temperature';
		assert: dataStream creationDateTime
			equals: self octoberFirstOf2014AtMidnight;
		assert: dataStream dataPoints isEmpty
]