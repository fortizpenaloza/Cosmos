Class {
	#name : #DataManagementSystemUserStoryTests,
	#superclass : #SystemBasedUserStoryTest,
	#category : 'Cosmos-Data-Tests-SystemModel'
}

{ #category : #tests }
DataManagementSystemUserStoryTests >> septemberSixth2015AtNoon [

	^ (September sixth , 2015) atNoon
]

{ #category : #running }
DataManagementSystemUserStoryTests >> setUpRequirements [

	super
		setUpRequirements;
		requireDataManagementSystem
]

{ #category : #tests }
DataManagementSystemUserStoryTests >> systemDateTime [

	^ self septemberSixth2015AtNoon
]

{ #category : #tests }
DataManagementSystemUserStoryTests >> testDataPointRegistration [

	| dataStream |
	
	dataStream := self dataManagementSystem
		registerStreamNamed: 'Temperature'.

	self dataManagementSystem register: 10 toStreamNamed: dataStream name.

	self
		withTheOnlyOneIn: dataStream dataPoints
		do: [ :dataPoint | 
			self
				assert: dataPoint value equals: 10;
				assert: dataPoint timestamp equals: self septemberSixth2015AtNoon ]
]

{ #category : #tests }
DataManagementSystemUserStoryTests >> testDataPointRegistrationFailsIfStreamNotFound [

	self
		should: [ self dataManagementSystem register: 10 toStreamNamed: 'Temperature' ]
		raise: ObjectNotFound
		withDescription: 'Data stream not found in the system'
]

{ #category : #tests }
DataManagementSystemUserStoryTests >> testDataStreamRegistration [

	| dataStream |

	dataStream := self dataManagementSystem
		registerStreamNamed: 'Temperature'.

	self
		assert: dataStream name equals: 'Temperature';
		assert: dataStream creationDateTime
			equals: self timeSystem dateTime
]

{ #category : #tests }
DataManagementSystemUserStoryTests >> testDataStreamRegistrationFailsIfAlreadyExists [

	self dataManagementSystem registerStreamNamed: 'Temperature'.

	self
		should:
			[ self dataManagementSystem registerStreamNamed: 'Temperature' ]
		raise: ConflictingObjectFound
		withDescription: 'A data stream with that name already exists in system'
]

{ #category : #tests }
DataManagementSystemUserStoryTests >> testQueryingDataStreamByName [

	self dataManagementSystem registerStreamNamed: 'Temperature'.

	self dataManagementSystem
		streamNamed: 'Temperature'
		ifFound: [ :dataStream | 
			self
				assert: dataStream name equals: 'Temperature';
				assert: dataStream creationDateTime equals: self timeSystem dateTime;
				assert: dataStream dataPoints isEmpty ]
		ifNone: [ self fail ]
]
