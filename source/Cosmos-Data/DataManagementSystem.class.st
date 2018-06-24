"
I'm a system that manages data. I allow the registration of streams and data points.
"
Class {
	#name : #DataManagementSystem,
	#superclass : #System,
	#instVars : [
		'dataStreams',
		'timeSystem',
		'eventNotificationSystem'
	],
	#category : #'Cosmos-Data-SystemModel'
}

{ #category : #'system specification' }
DataManagementSystem class >> implementedInterface [

	^ SystemInterface >> #DataManagementSystemInterface 
]

{ #category : #'initialize-release' }
DataManagementSystem >> initialize [

	super initialize.

	timeSystem := self unresolvedSystemDependencyTo: #TimeSystemInterface.
	eventNotificationSystem := self unresolvedSystemDependencyTo: #EventNotificationSystemInterface.

	dataStreams := OrderedCollection new
]

{ #category : #managing }
DataManagementSystem >> register: aValue toStreamNamed: aName [

	| dataPoint |

	dataPoint := DataPoint on: timeSystem dateTime holding: aValue.

	self
		streamNamed: aName
		ifFound: [ :dataStream | self registerPoint: dataPoint to: dataStream ]
		ifNone: [ ObjectNotFound
				signal: 'Data stream not found in the system' ].

	^ dataPoint
]

{ #category : #'private-managing' }
DataManagementSystem >> registerPoint: aDataPoint to: aDataStream [

	aDataStream add: aDataPoint.

	eventNotificationSystem
		notifySubscribersTo: (DataPointRegistrationEvent on: aDataStream)
]

{ #category : #'private-managing' }
DataManagementSystem >> registerStream: aDataStream [

	^ dataStreams add: aDataStream
]

{ #category : #managing }
DataManagementSystem >> registerStreamNamed: aName [

	^ self
		streamNamed: aName
		ifFound: [ :dataStream | 
			ConflictingObjectFound
				signal: 'A data stream with that name already exists in system' ]
		ifNone: [ self
				registerStream: (DataStream named: aName createdOn: timeSystem dateTime) ]
]

{ #category : #'dependency resolution' }
DataManagementSystem >> resolveDependecies [

	timeSystem := self resolveSystemDependencyTo: #TimeSystemInterface.
	eventNotificationSystem := self resolveSystemDependencyTo: #EventNotificationSystemInterface
]

{ #category : #querying }
DataManagementSystem >> streamNamed: aName ifFound: aFoundBlock ifNone: aNoneBlock [

	^ dataStreams 	
		detect: [ :dataStream | dataStream name = aName ]
		ifFound: [ :dataStream | aFoundBlock value: dataStream ]
		ifNone: aNoneBlock
]

{ #category : #querying }
DataManagementSystem >> streams [

	^ dataStreams copy 
]
