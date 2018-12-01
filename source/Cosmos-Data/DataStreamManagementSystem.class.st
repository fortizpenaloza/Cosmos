"
I'm a system that manages data. I allow the registration of streams and data points on them.

I also allow deregistration of streams.
"
Class {
	#name : #DataStreamManagementSystem,
	#superclass : #System,
	#instVars : [
		'dataStreams',
		'timeSystem',
		'eventNotificationSystem',
		'metadataSystem',
		'identifierSystem'
	],
	#category : #'Cosmos-Data'
}

{ #category : #'system specification' }
DataStreamManagementSystem class >> implementedInterface [

	^ SystemInterface >> #DataStreamManagementSystemInterface 
]

{ #category : #managing }
DataStreamManagementSystem >> deregister: aDataStream [ 
	
	dataStreams remove: aDataStream 
]

{ #category : #initialization }
DataStreamManagementSystem >> initialize [

	super initialize.

	timeSystem := self unresolvedSystemDependencyTo: #TimeSystemInterface.
	eventNotificationSystem := self unresolvedSystemDependencyTo: #EventNotificationSystemInterface.
	metadataSystem := self unresolvedSystemDependencyTo: #MetadataSystemInterface.
	identifierSystem := self unresolvedSystemDependencyTo: #IdentifierSystemInterface.

	dataStreams := OrderedCollection new
]

{ #category : #'events handling' }
DataStreamManagementSystem >> notifyDataPointWasRegisteredOn: aDataStream [

	eventNotificationSystem
		notifySubscribersTo: (DataPointRegistrationEvent on: aDataStream)
]

{ #category : #managing }
DataStreamManagementSystem >> register: aDataStream [

	self
		streamNamed: aDataStream name
		ifFound: [ :dataStream | 
			ConflictingObjectFound
				signal: 'A data stream with that name already exists in system' ]
		ifNone: [ self registerWithMetadata: aDataStream ].
		
	^ aDataStream 
]

{ #category : #'private - managing' }
DataStreamManagementSystem >> register: aDataPoint to: aDataStream [

	aDataStream add: aDataPoint.
	self notifyDataPointWasRegisteredOn: aDataStream
]

{ #category : #managing }
DataStreamManagementSystem >> register: aDataPoint toStreamNamed: aName [

	self
		streamNamed: aName
		ifFound: [ :dataStream | self register: aDataPoint to: dataStream ]
		ifNone: [ ObjectNotFound signal: 'Data stream not found in the system' ]
]

{ #category : #'private - managing' }
DataStreamManagementSystem >> registerIdentifierFor: aDataStream [

	identifierSystem registerIdentifierFor: aDataStream
]

{ #category : #'private - managing' }
DataStreamManagementSystem >> registerRegistrationTimestampFor: aDataStream [

	metadataSystem
		register:
			(Metadata
				attaching: timeSystem dateTime
				as: #registration_timestamp
				of: aDataStream)
]

{ #category : #'private - managing' }
DataStreamManagementSystem >> registerWithMetadata: aDataStream [

	dataStreams add: aDataStream.

	self registerIdentifierFor: aDataStream.
	self registerRegistrationTimestampFor: aDataStream
]

{ #category : #'private - dependency resolution' }
DataStreamManagementSystem >> resolveDependecies [

	timeSystem := self resolveSystemDependencyTo: #TimeSystemInterface.
	eventNotificationSystem := self
		resolveSystemDependencyTo: #EventNotificationSystemInterface.
	metadataSystem := self resolveSystemDependencyTo: #MetadataSystemInterface.
	identifierSystem := self resolveSystemDependencyTo: #IdentifierSystemInterface
]

{ #category : #querying }
DataStreamManagementSystem >> streamIdentifiedBy: anIdentifier [

	^ identifierSystem
		objectIdentifiedBy: anIdentifier
		ifNone:
			[ ObjectNotFound signal: 'Data stream with that identifier not found' ]
]

{ #category : #'private - querying' }
DataStreamManagementSystem >> streamNamed: aName ifFound: aFoundBlock ifNone: aNoneBlock [

	^ dataStreams 	
		detect: [ :dataStream | dataStream name = aName ]
		ifFound: [ :dataStream | aFoundBlock value: dataStream ]
		ifNone: aNoneBlock
]

{ #category : #querying }
DataStreamManagementSystem >> streams [

	^ dataStreams copy 
]
