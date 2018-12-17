Class {
	#name : #DataStreamManagementSystemUserStoryTests,
	#superclass : #SystemBasedUserStoryTest,
	#category : #'Cosmos-Data-Tests'
}

{ #category : #accessing }
DataStreamManagementSystemUserStoryTests >> octoberFirstOf2014AtNoon [

	^ (October first , 2014) atNoon
]

{ #category : #running }
DataStreamManagementSystemUserStoryTests >> setUpRequirements [

	self
		registerSubsystem: (TimeSystem using: (FixedTimeSource on: self octoberFirstOf2014AtNoon));
		registerSubsystem: EventNotificationSystem new;
		registerSubsystem: MetadataSystem new;
		registerSubsystem: (IdentifierSystem using: self identifierProvider);
		registerSubsystem: (TimestampingSystem new);
		registerSubsystem: DataStreamManagementSystem new
]

{ #category : #accessing }
DataStreamManagementSystemUserStoryTests >> temperatureStream [

	^ DataStream named: 'Temperature'
]

{ #category : #tests }
DataStreamManagementSystemUserStoryTests >> testAccessing [ 
	
	self assert: self dataManagementSystem name equals: 'Data Stream Management'
	
]

{ #category : #tests }
DataStreamManagementSystemUserStoryTests >> testDataPointRegistration [

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
DataStreamManagementSystemUserStoryTests >> testDataPointRegistrationFailsIfStreamNotFound [

	self
		should: [ self dataManagementSystem
				register: (DataPoint on: self octoberFirstOf2014AtNoon holding: 10)
				toStreamNamed: 'Wrong name' ]
		raise: ObjectNotFound
		withMessageText: 'Data stream named "Wrong name" not found'
]

{ #category : #tests }
DataStreamManagementSystemUserStoryTests >> testDataStreamDeregistration [

	| dataStream |

	dataStream := self temperatureStream.

	self assert: self dataManagementSystem streams isEmpty.
	self dataManagementSystem register: dataStream.
	self deny: self dataManagementSystem streams isEmpty.

	self dataManagementSystem deregister: dataStream.
	self assert: self dataManagementSystem streams isEmpty
]

{ #category : #tests }
DataStreamManagementSystemUserStoryTests >> testDataStreamRegistration [

	| dataStream |

	dataStream := self temperatureStream.

	self assert: self dataManagementSystem streams isEmpty.
	self dataManagementSystem register: dataStream.
	self
		withTheOnlyOneIn: self dataManagementSystem streams
		do: [ :foundDataStream | self assert: dataStream equals: foundDataStream ]
]

{ #category : #tests }
DataStreamManagementSystemUserStoryTests >> testDataStreamRegistrationFailsIfAlreadyExists [

	self dataManagementSystem register: self temperatureStream.

	self
		should:
			[ self dataManagementSystem register: self temperatureStream ]
		raise: ConflictingObjectFound
		withMessageText: 'A data stream with that name already exists in system'
]

{ #category : #tests }
DataStreamManagementSystemUserStoryTests >> testMedataRegistrationOnDataStreamRegistration [

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
				attaching: self octoberFirstOf2014AtNoon
				as: #update_timestamp
				of: dataStream)} asOrderedCollection 
]

{ #category : #tests }
DataStreamManagementSystemUserStoryTests >> testQueryingDataStreamByIdentifier [

	| dataStream |

	dataStream := self temperatureStream.
	self dataManagementSystem register: dataStream.
	
	self
		assert: (self dataManagementSystem streamIdentifiedBy: self currentIdentifier)
		equals: dataStream
]

{ #category : #tests }
DataStreamManagementSystemUserStoryTests >> testQueryingDataStreamByName [

	| dataStream |

	dataStream := self temperatureStream.

	self dataManagementSystem register: dataStream.
	self dataManagementSystem
		streamNamed: 'Temperature'
		ifFound: [ :foundDataStream | self assert: foundDataStream equals: dataStream ]
]

{ #category : #tests }
DataStreamManagementSystemUserStoryTests >> testQueryingDataStreamUsingWrongIdentifierGivesObjectNotFound [

	| dataStream |

	dataStream := self temperatureStream.
	self dataManagementSystem register: dataStream.

	self
		should: [ self dataManagementSystem streamIdentifiedBy: 2 ]
		raise: ObjectNotFound
		withExceptionDo:
			[ :signal | self assert: signal messageText equals: 'Data stream with that identifier not found' ]
]
