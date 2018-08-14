Class {
	#name : #DataStreamTest,
	#superclass : #TestCase,
	#category : #'Cosmos-Data-Tests'
}

{ #category : #history }
DataStreamTest class >> lastStoredRun [
	^ ((Dictionary new) add: (#timeStamp->(DateAndTime basicNew instVarAt: 1 put: 6510; instVarAt: 2 put: (Duration seconds: -10800 nanoSeconds: 0); instVarAt: 3 put: 2458339; instVarAt: 4 put: 626098000; yourself)); add: (#passed->((Set new) add: #testInstanceCreationAndAccessing; add: #testAccessingLastUpdate; add: #testAddingDataPoint; add: #testAccessingCurrentValue; yourself)); add: (#failures->((Set new))); add: (#errors->((Set new))); yourself)
]

{ #category : #accessing }
DataStreamTest >> octoberFirstOf2014AtMidnight [

	^ (October first, 2014) atMidnight
]

{ #category : #tests }
DataStreamTest >> testAccessingCurrentValue [

	| dataStream dataPoint |

	dataStream := DataStream named: 'Temperature'.

	self
		should: [ dataStream currentValue ]
		raise: DataStreamIsEmpty
		withDescription: 'Current value has not been initialized'.

	dataPoint := DataPoint
		on: self octoberFirstOf2014AtMidnight
		holding: 10.
	dataStream add: dataPoint.
	self assert: dataStream currentValue equals: 10
]

{ #category : #tests }
DataStreamTest >> testAccessingLastUpdate [

	| dataStream dataPoint |

	dataStream := DataStream named: 'Temperature'.

	self
		should: [ dataStream lastUpdate ]
		raise: DataStreamIsEmpty
		withDescription: 'Last update date and time has not been initialized'.

	dataPoint := DataPoint
		on: self octoberFirstOf2014AtMidnight
		holding: 10.
	dataStream add: dataPoint.
	self assert: dataStream lastUpdate equals: dataPoint timestamp
]

{ #category : #tests }
DataStreamTest >> testAddingDataPoint [

	| dataStream |

	dataStream := DataStream named: 'Temperature'.

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

	dataStream := DataStream named: 'Temperature'.

	self
		assert: dataStream name equals: 'Temperature';
		assert: dataStream dataPoints isEmpty
]
