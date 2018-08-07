"
I'm a system that manages data. I allow the registration of streams and data points on them.

I also allow deregistration of streams.
"
Class {
	#name : #DataManagementSystem,
	#superclass : #System,
	#instVars : [
		'dataStreams',
		'timeSystem',
		'eventNotificationSystem',
		'metadataSystem'
	],
	#category : #'Cosmos-Data'
}

{ #category : #'system specification' }
DataManagementSystem class >> implementedInterface [

	^ SystemInterface >> #DataManagementSystemInterface 
]

{ #category : #managing }
DataManagementSystem >> deregister: aDataStream [ 
	
	dataStreams remove: aDataStream 
]

{ #category : #initialization }
DataManagementSystem >> initialize [

	super initialize.

	timeSystem := self unresolvedSystemDependencyTo: #TimeSystemInterface.
	eventNotificationSystem := self unresolvedSystemDependencyTo: #EventNotificationSystemInterface.
	metadataSystem := self unresolvedSystemDependencyTo: #MetadataSystemInterface.

	dataStreams := OrderedCollection new
]

{ #category : #managing }
DataManagementSystem >> register: aDataStream [

	self
		streamNamed: aDataStream name
		ifFound:
			[ :dataStream | ConflictingObjectFound signal: 'A data stream with that name already exists in system' ]
		ifNone: [ 
			dataStreams add: aDataStream.
			
			self registerIdentifierAsMetadataFor: aDataStream.
			self registerRegistrationTimestampAsMetadataFor: aDataStream ]
]

{ #category : #'private-managing' }
DataManagementSystem >> register: aDataPoint to: aDataStream [

	aDataStream add: aDataPoint.

	eventNotificationSystem
		notifySubscribersTo: (DataPointRegistrationEvent on: aDataStream)
]

{ #category : #managing }
DataManagementSystem >> register: aDataPoint toStreamNamed: aName [

	self
		streamNamed: aName
		ifFound: [ :dataStream | self register: aDataPoint to: dataStream ]
		ifNone: [ ObjectNotFound signal: 'Data stream not found in the system' ]
]

{ #category : #'private-managing' }
DataManagementSystem >> registerIdentifierAsMetadataFor: aDataStream [

	metadataSystem
		register: (Metadata about: aDataStream where: #identifier is: UUID new)
]

{ #category : #'private-managing' }
DataManagementSystem >> registerRegistrationTimestampAsMetadataFor: aDataStream [

  metadataSystem
		register:
			(Metadata
				about: aDataStream
				where: #registration_timestamp
				is: timeSystem dateTime)
]

{ #category : #'dependency resolution' }
DataManagementSystem >> resolveDependecies [

	timeSystem := self resolveSystemDependencyTo: #TimeSystemInterface.
	eventNotificationSystem := self
		resolveSystemDependencyTo: #EventNotificationSystemInterface.
	metadataSystem := self
		resolveSystemDependencyTo: #MetadataSystemInterface
]

{ #category : #querying }
DataManagementSystem >> streamIdentifiedBy: anIdentifier ifFound: aBlockClosure ifNone: aBlockClosure3 [

	^ metadataSystem objectWhere: #identifier is: anIdentifier
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
