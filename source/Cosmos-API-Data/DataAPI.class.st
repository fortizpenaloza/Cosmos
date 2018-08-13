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
	rawData := context decode: anHttpRequest contents encodedAs: anHttpRequest contentType.

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

	^ [ [ | rawStream dataStream identifier |

	rawStream := (NeoJSONReader on: anHttpRequest contents readStream)
		propertyNamesAsSymbols: true;
		next.

	dataStream := DataStream
		named: (rawStream at: #name)
		createdOn: self currentDateTime.

	self dataManagementSystem register: dataStream.

	identifier := ((context metadataSystem metadataFor: dataStream)
		detect: [ :metadata | metadata aspect = #identifier ]) value.

	ZnResponse
		created:
			(ZnUrl
				fromString: ('localhost/<1p>' expandMacrosWith: identifier asString36)) ]
		on: ConflictingObjectFound
		do: [ :signal | HTTPClientError signalConflict: signal messageText ] ]
		on: KeyNotFound , InstanceCreationFailed
		do: [ :signal | HTTPClientError signalBadRequest: signal messageText ]
]

{ #category : #'private - accessing' }
DataAPI >> currentDateTime [

	^ self timeSystem dateTime
]

{ #category : #systems }
DataAPI >> dataManagementSystem [

	^ context dataManagementSystem
]

{ #category : #API }
DataAPI >> deleteStreamBasedOn: anHttpRequest [

	^ [ | identifier |

	identifier := anHttpRequest at: #identifier.

	self dataManagementSystem
		streamIdentifiedBy: identifier
		ifFound: [ :foundStream | 
			self dataManagementSystem deregister: foundStream.
			ZnResponse noContent ]
		ifNone: [ ObjectNotFound signal: 'Data stream with that identifier not found' ] ]
		on: ObjectNotFound
		do: [ :signal | HTTPClientError signalNotFound: signal messageText ]
]

{ #category : #API }
DataAPI >> getPointsBasedOn: anHttpRequest [


	^ [ [ | mimeType encodedPoints identifier |

	mimeType := ZnMimeType fromString: anHttpRequest accept.
	identifier := anHttpRequest at: #identifier.

	encodedPoints := self dataManagementSystem 
		streamIdentifiedBy: identifier
		ifFound: [ :dataStream | context encode: dataStream dataPoints to: mimeType ]
		ifNone: [ ObjectNotFound signal: 'Data stream with that identifier not found' ].

	ZnResponse ok: (ZnEntity json: encodedPoints) ]
		on: TeaNoSuchParam
		do: [ :signal | HTTPClientError signalBadRequest: signal messageText ] ]
		on: ObjectNotFound
		do: [ :signal | HTTPClientError signalNotFound: signal messageText ]
]

{ #category : #API }
DataAPI >> getStreamBasedOn: anHttpRequest [

	^ [ [ | mimeType identifier |

	mimeType := ZnMimeType fromString: anHttpRequest accept.
	identifier := anHttpRequest at: #identifier.

	ZnResponse
		ok: (ZnEntity json: (self streamNamed: identifier encodedTo: mimeType)) ]
		on: TeaNoSuchParam
		do: [ :signal | HTTPClientError signalBadRequest: signal messageText ] ]
		on: ObjectNotFound
		do: [ :signal | HTTPClientError signalNotFound: signal messageText ]
]

{ #category : #API }
DataAPI >> getStreamsSnapshotsBasedOn: anHttpRequest [

	| mimeType |

	mimeType := ZnMimeType fromString: anHttpRequest accept.


	^ ZnResponse
		ok:
			(ZnEntity json: (self streamsEncodedTo: mimeType))
]

{ #category : #initialization }
DataAPI >> initializeWorkingWithin: aContext [

	context := aContext
]

{ #category : #'private-API' }
DataAPI >> streamNamed: aName encodedTo: mimeType [

	^ [ self dataManagementSystem
		streamIdentifiedBy: aName
		ifFound: [ :dataStream | context encode: dataStream to: mimeType ]
		ifNone: [ ObjectNotFound signal: 'Data stream with that identifier not found' ] ]
		on: DataStreamIsEmpty
		do: [ :signal | signal resume: 'N/A' ]
]

{ #category : #'private-API' }
DataAPI >> streamsEncodedTo: mimeType [

	^ [ context encode: self dataManagementSystem streams to: mimeType ]
		on: DataStreamIsEmpty
		do: [ :signal | signal resume: 'N/A' ]
]

{ #category : #'private - systems' }
DataAPI >> timeSystem [
	
	^ context timeSystem
]
