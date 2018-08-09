"
A DataPointTest is a test class for testing the behavior of DataPoint
"
Class {
	#name : #DataPointTest,
	#superclass : #TestCase,
	#category : #'Cosmos-Data-Tests'
}

{ #category : #tests }
DataPointTest >> octoberFirstOf2016atNoon [

	^ (October first , 2016) atNoon
]

{ #category : #tests }
DataPointTest >> testPrintOn [

	| dataPoint |

	dataPoint := DataPoint on: self octoberFirstOf2016atNoon holding: 10.
	self
		assert: dataPoint printString
		equals: ('<1p>-<2p>' expandMacrosWith: dataPoint timestamp with: dataPoint value)
]

{ #category : #tests }
DataPointTest >> testTimestamp [

	| dataPoint |

	dataPoint := DataPoint on: self octoberFirstOf2016atNoon holding: 10.
	self assert: dataPoint timestamp equals: self octoberFirstOf2016atNoon
]

{ #category : #tests }
DataPointTest >> testValue [

	| dataPoint |

	dataPoint := DataPoint on: self octoberFirstOf2016atNoon holding: 10.
	self assert: dataPoint value equals: 10
]
