Class {
	#name : #DataManagementSystemUserStoryTests,
	#superclass : #SystemBasedUserStoryTest,
	#category : #'Cosmos-Data-Tests'
}

{ #category : #tests }
DataManagementSystemUserStoryTests >> octoberFirstOf2014AtNoon [

	^ (October first , 2014) atNoon
]

{ #category : #running }
DataManagementSystemUserStoryTests >> setUpRequirements [

	super
		setUpRequirements;
		requireDataManagementSystem
]

{ #category : #tests }
DataManagementSystemUserStoryTests >> temperatureStream [

	^ DataStream named: 'Temperature'
]

{ #category : #tests }
DataManagementSystemUserStoryTests >> testDataPointRegistration [

	| dataStream dataPoint |

	dataStream := self temperatureStream.
	self dataManagementSystem register: dataStream.
	
	dataPoint := DataPoint on: self octoberFirstOf2014AtNoon holding: 10.
	self dataManagementSystem register: dataPoint toStreamNamed: dataStream name.

	self
		withTheOnlyOneIn: dataStream dataPoints
		do: [ :foundDataPoint | self assert: dataPoint equals: foundDataPoint ]
]

{ #category : #tests }
DataManagementSystemUserStoryTests >> testDataPointRegistrationFailsIfStreamNotFound [

	self
		should: [ self dataManagementSystem
				register: (DataPoint on: self octoberFirstOf2014AtNoon holding: 10)
				toStreamNamed: 'Wrong name' ]
		raise: ObjectNotFound
		withDescription: 'Data stream not found in the system'
]

{ #category : #tests }
DataManagementSystemUserStoryTests >> testDataStreamDeregistration [

	| dataStream |

	dataStream := self temperatureStream.

	self assert: self dataManagementSystem streams isEmpty.
	self dataManagementSystem register: dataStream.
	self deny: self dataManagementSystem streams isEmpty.

	self dataManagementSystem deregister: dataStream.
	self assert: self dataManagementSystem streams isEmpty
]

{ #category : #tests }
DataManagementSystemUserStoryTests >> testDataStreamRegistration [

	| dataStream |

	dataStream := self temperatureStream.

	self assert: self dataManagementSystem streams isEmpty.
	self dataManagementSystem register: dataStream.
	self
		withTheOnlyOneIn: self dataManagementSystem streams
		do: [ :foundDataStream | self assert: dataStream equals: foundDataStream ]
]

{ #category : #tests }
DataManagementSystemUserStoryTests >> testDataStreamRegistrationFailsIfAlreadyExists [

	self dataManagementSystem register: self temperatureStream.

	self
		should:
			[ self dataManagementSystem register: self temperatureStream ]
		raise: ConflictingObjectFound
		withDescription: 'A data stream with that name already exists in system'
]

{ #category : #tests }
DataManagementSystemUserStoryTests >> testQueryingDataStreamByIdentifier [

	| dataStream |

	dataStream := self temperatureStream.
	self dataManagementSystem register: dataStream.

	self dataManagementSystem
		streamIdentifiedBy: self currentIdentifier
		ifFound: [ :foundDataStream | self assert: foundDataStream equals: dataStream ]
		ifNone: [ self fail ]
]

{ #category : #tests }
DataManagementSystemUserStoryTests >> testQueryingDataStreamByName [

	| dataStream |

	dataStream := self temperatureStream.
	
	self dataManagementSystem register: dataStream.
	self dataManagementSystem
		streamNamed: 'Temperature'
		ifFound: [ :foundDataStream | self assert: foundDataStream equals: dataStream ]
		ifNone: [ self fail ]
]

{ #category : #tests }
DataManagementSystemUserStoryTests >> testRegisteredMetadataOnDataStreamRegistration [

	| dataStream metadata |

	dataStream := self temperatureStream.

	self assert: (self metadataSystem metadataFor: dataStream) isEmpty.
	self dataManagementSystem register: dataStream.

	metadata := self metadataSystem metadataFor: dataStream.
	self
		assert: metadata size equals: 2;
		assert: metadata
			equals:
			{(Metadata
				attaching: self currentIdentifier
				as: #identifier
				of: dataStream).
			(Metadata
				attaching: self systemDateTime
				as: #registration_timestamp
				of: dataStream)} asOrderedCollection 
]
