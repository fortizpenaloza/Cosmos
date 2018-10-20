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
		'metadataSystem',
		'identifierSystem'
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
	identifierSystem := self unresolvedSystemDependencyTo: #IdentifierSystemInterface.

	dataStreams := OrderedCollection new
]

{ #category : #managing }
DataManagementSystem >> register: aDataStream [

	self
		streamNamed: aDataStream name
		ifFound: [ :dataStream | 
			ConflictingObjectFound
				signal: 'A data stream with that name already exists in system' ]
		ifNone: [ self registerWithMetadata: aDataStream ].
		
	^ aDataStream 
]

{ #category : #'private - managing' }
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

{ #category : #'private - managing' }
DataManagementSystem >> registerIdentifierFor: aDataStream [

	identifierSystem registerIdentifierFor: aDataStream
]

{ #category : #'private - managing' }
DataManagementSystem >> registerRegistrationTimestampFor: aDataStream [

	metadataSystem
		register:
			(Metadata
				attaching: timeSystem dateTime
				as: #registration_timestamp
				of: aDataStream)
]

{ #category : #'private - managing' }
DataManagementSystem >> registerWithMetadata: aDataStream [

	dataStreams add: aDataStream.

	self registerIdentifierFor: aDataStream.
	self registerRegistrationTimestampFor: aDataStream
]

{ #category : #'private - dependency resolution' }
DataManagementSystem >> resolveDependecies [

	timeSystem := self resolveSystemDependencyTo: #TimeSystemInterface.
	eventNotificationSystem := self
		resolveSystemDependencyTo: #EventNotificationSystemInterface.
	metadataSystem := self
		resolveSystemDependencyTo: #MetadataSystemInterface.
	identifierSystem := self
		resolveSystemDependencyTo: #IdentifierSystemInterface
]

{ #category : #querying }
DataManagementSystem >> streamIdentifiedBy: anIdentifier [

	^ identifierSystem
		objectIdentifiedBy: anIdentifier
		ifNone:
			[ ObjectNotFound signal: 'Data stream with that identifier not found' ]
]

{ #category : #'private - querying' }
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

{ #category : #querying }
DataManagementSystem >> withStreamIdentifiedBy: anIdentifier do: aBlock [

	aBlock value: (self streamIdentifiedBy: anIdentifier)
]
