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

{ #category : #systems }
DataAPI >> dataManagementSystem [

	^ context dataManagementSystem
]

{ #category : #initialization }
DataAPI >> initializeWorkingWithin: aContext [

	context := aContext
]

{ #category : #API }
DataAPI >> registerBulkPointsBasedOn: anHttpRequest [

	^ [ | registrationDateTime rawData |

	registrationDateTime := self timeSystem dateTime.
	rawData := context decode: anHttpRequest contents encodedAs: anHttpRequest contentType.

	rawData
		do: [ :rawDataPoint | 
			context
				register: (DataPoint on: registrationDateTime holding: (rawDataPoint at: 'value'))
				toStreamNamed: (rawDataPoint at: 'data-stream') ].

	ZnResponse created: 'all' ]
		on: KeyNotFound
		do: [ :signal | 
			HTTPClientError
				signalBadRequest:
					('{"error":{"code":400,"message":"Expected key <1s> was not found"}' expandMacrosWith: signal key) ]
]

{ #category : #API }
DataAPI >> registerStreamBasedOn: anHttpRequest [
	
	
	^ [ [ | rawStream dataStream identifier|

	rawStream := (NeoJSONReader on: anHttpRequest contents readStream)
		propertyNamesAsSymbols: true;
		next.

	dataStream := DataStream named: (rawStream at: #name) createdOn: self timeSystem dateTime.

	self dataManagementSystem register: dataStream.
	
	identifier := ((context metadataSystem metadataFor: dataStream) detect: [:metadata | metadata aspect = #identifier ]) value .

	ZnResponse created: (ZnUrl fromString: ('localhost/<1p>' expandMacrosWith: identifier))  ]
		on: ConflictingObjectFound
		do: [ :signal | HTTPClientError signalConflict: signal messageText ] ]
		on: KeyNotFound, InstanceCreationFailed 
		do: [ :signal | HTTPClientError signalBadRequest: signal messageText ]
]

{ #category : #API }
DataAPI >> streamBasedOn: anHttpRequest [

	| mimeType aName |

	mimeType := ZnMimeType fromString: anHttpRequest accept.
	aName := anHttpRequest at: #name.

	^ [ ZnResponse
		ok:
			(ZnEntity json: (self streamNamed: aName encodedTo: mimeType)) ]
		on: ObjectNotFound
		do: [ :signal | HTTPClientError signalBadRequest: signal messageText ]
]

{ #category : #'private-API' }
DataAPI >> streamNamed: aName encodedTo: mimeType [

	^ [ self dataManagementSystem
		streamNamed: aName
		ifFound: [ :dataStream | context encode: dataStream to: mimeType ]
		ifNone: [ ObjectNotFound signal: 'Data stream with that name not found' ] ]
		on: DataStreamIsEmpty
		do: [ :signal | signal resume: 'N/A' ]
]

{ #category : #'private-API' }
DataAPI >> streamsEncodedTo: mimeType [

	^ [ context encode: self dataManagementSystem streams to: mimeType ]
		on: DataStreamIsEmpty
		do: [ :signal | signal resume: 'N/A' ]
]

{ #category : #API }
DataAPI >> streamsSnapshotsBasedOn: anHttpRequest [

	| mimeType |

	mimeType := ZnMimeType fromString: anHttpRequest accept.


	^ ZnResponse
		ok:
			(ZnEntity json: (self streamsEncodedTo: mimeType))
]

{ #category : #'private - systems' }
DataAPI >> timeSystem [
	
	^ context timeSystem
]
