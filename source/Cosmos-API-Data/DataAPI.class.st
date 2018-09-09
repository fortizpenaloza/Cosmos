Class {
	#name : #DataAPI,
	#superclass : #Object,
	#instVars : [
		'context'
	],
	#category : #'Cosmos-API-Data'
}

{ #category : #'instance creation' }
DataAPI class >> workingWithin: aContext [ 
	
	^self new initializeWorkingWithin: aContext 
]

{ #category : #API }
DataAPI >> createBulkPointsBasedOn: anHttpRequest [

	^ [ | timestamp rawData |

	timestamp := self currentDateTime.

	rawData := context
		decode: anHttpRequest contents
		encodedAs: anHttpRequest contentType
		to: self dataPointsKey.

	rawData
		do: [ :rawDataPoint | 
			self dataManagementSystem
				register: (DataPoint on: timestamp holding: (rawDataPoint at: 'value'))
				toStreamNamed: (rawDataPoint at: 'data-stream') ].

	ZnResponse created: 'all' ]
		on: KeyNotFound
		do: [ :signal | 
			HTTPClientError
				signalBadRequest:
					('{"error":{"code":400,"message":"Expected key <1s> was not found"}'
						expandMacrosWith: signal key) ]
]

{ #category : #API }
DataAPI >> createStreamBasedOn: anHttpRequest [

	^  [ [ [ | dataStream dataStreamLocation |

	dataStream := context
		decode: anHttpRequest contents
		encodedAs: anHttpRequest contentType
		to: #data_streams.

	self dataManagementSystem register: dataStream.

	dataStreamLocation := self locationOf: dataStream.

	ZnResponse created: dataStreamLocation ]
		on: ConflictingObjectFound
		do: [ :signal | HTTPClientError signalConflict: signal messageText ] ]
		on: KeyNotFound , InstanceCreationFailed
		do: [ :signal | HTTPClientError signalBadRequest: signal messageText ] ]
		on: MappingNotFound
		do: [ :signal | HTTPClientError signalUnsupportedMediaType: signal messageText ]
]

{ #category : #'private - accessing' }
DataAPI >> currentDateTime [

	^ self timeSystem dateTime
]

{ #category : #'private - systems' }
DataAPI >> dataManagementSystem [

	^ context systemImplementing: #DataManagementSystemInterface
]

{ #category : #'private - object types' }
DataAPI >> dataPointsKey [

	^ #data_points
]

{ #category : #API }
DataAPI >> deleteStreamBasedOn: anHttpRequest [

	^ [ 
	self dataManagementSystem
		withStreamIdentifiedBy: (anHttpRequest at: #identifier)
		do: [ :dataStream | self dataManagementSystem deregister: dataStream ].

	ZnResponse noContent ]
		on: ObjectNotFound
		do: [ :signal | HTTPClientError signalNotFound: signal messageText ]
]

{ #category : #API }
DataAPI >> getPointsBasedOn: anHttpRequest [

	^ [ [ | mediaType encodedPoints |

	mediaType := ZnMimeType fromString: anHttpRequest accept.

	self dataManagementSystem
		withStreamIdentifiedBy: (anHttpRequest at: #identifier)
		do: [ :dataStream | 
			encodedPoints := context
				encode: dataStream dataPoints
				of: #data_points
				to: mediaType ].

	ZnResponse ok: (ZnEntity json: encodedPoints) ]
		on: TeaNoSuchParam
		do: [ :signal | HTTPClientError signalBadRequest: signal messageText ] ]
		on: ObjectNotFound
		do: [ :signal | HTTPClientError signalNotFound: signal messageText ]
]

{ #category : #API }
DataAPI >> getStreamsBasedOn: anHttpRequest [

	^ [ [ [ | mediaType streamsToEncode encodedStreams |

	mediaType := ZnMimeType fromString: anHttpRequest accept.

	self
		withIdentifierProvidedIn: anHttpRequest
		do: [ :identifier | 
			self dataManagementSystem
				withStreamIdentifiedBy: identifier
				do: [ :dataStream | streamsToEncode := dataStream ] ]
		ifNone: [ streamsToEncode := self dataManagementSystem streams ].

	encodedStreams := context encode: streamsToEncode of: #data_streams to: mediaType.

	ZnResponse ok: (ZnEntity json: encodedStreams) ]
		on: TeaNoSuchParam
		do: [ :signal | HTTPClientError signalBadRequest: signal messageText ] ]
		on: ObjectNotFound
		do: [ :signal | HTTPClientError signalNotFound: signal messageText ] ]
		on: DataStreamIsEmpty
		do: [ :signal | signal resume: 'N/A' ]
]

{ #category : #'private - systems' }
DataAPI >> identifierSystem [

	^ context systemImplementing: #IdentifierSystemInterface
]

{ #category : #initialization }
DataAPI >> initializeWorkingWithin: aContext [

	context := aContext
]

{ #category : #'private - API' }
DataAPI >> locationOf: dataStream [

	^ ZnUrl
		fromString: ('localhost/<1s>' expandMacrosWith: (self identifierSystem identifierOf: dataStream) asString36)
]

{ #category : #'private - systems' }
DataAPI >> metadataSystem [
	
	^ context systemImplementing: #MetadataSystemInterface
]

{ #category : #'private - systems' }
DataAPI >> timeSystem [
	
	^ context timeSystem
]

{ #category : #'private - API' }
DataAPI >> withIdentifierProvidedIn: anHttpRequest do: aBlock ifNone: ifNoneBlock [

	| identifierProvided |

	identifierProvided := true.
	anHttpRequest at: #identifier ifAbsent: [ identifierProvided := false ].

	identifierProvided
		ifTrue: [ aBlock value: (anHttpRequest at: #identifier) ]
		ifFalse: ifNoneBlock
]
