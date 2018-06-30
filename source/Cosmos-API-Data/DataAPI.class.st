Class {
	#name : #DataAPI,
	#superclass : #Object,
	#instVars : [
		'dataStreamMapping',
		'dataStreamsSnapshotsMapping',
		'context'
	],
	#category : #'Cosmos-API-Data'
}

{ #category : #'instance creation' }
DataAPI class >> workingWithin: aCompositeSystem [ 
	
	^self new initializeWorkingWithin: aCompositeSystem 
]

{ #category : #systems }
DataAPI >> dataManagementSystem [

	^ context dataManagementSystem
]

{ #category : #initialization }
DataAPI >> initializeMappings [

	dataStreamsSnapshotsMapping := [ :object | 
	String
		streamContents: [ :stream | 
			(NeoJSONWriter on: stream)
				for: DataStream
					do: [ :mapping | 
					mapping
						mapAccessor: #name;
						mapAccessor: #currentValue to: 'current-value';
						mapAccessor: #lastUpdate to: 'last-update' ];
				for: DateTime
					customDo: [ :mapping | 
					mapping
						encoder: [ :dateTime | ISO8601DateTimeFormatter usingExtendedFormat format: dateTime ] ];
				prettyPrint: true;
				nextPut: object ] ].

	dataStreamMapping := [ :object | 
	String
		streamContents: [ :stream | 
			(NeoJSONWriter on: stream)
				for: DataStream
					do: [ :mapping | 
					mapping
						mapAccessor: #name;
						mapAccessor: #currentValue to: 'current-value';
						mapAccessor: #lastUpdate to: 'last-update';
						mapAccessor: #dataPoints to: 'data-points' ];
				for: DataPoint
					do: [ :mapping | 
					mapping
						mapAccessor: #timestamp;
						mapAccessor: #value ];
				for: DateTime
					customDo: [ :mapping | 
					mapping
						encoder: [ :dateTime | ISO8601DateTimeFormatter usingExtendedFormat format: dateTime ] ];
				prettyPrint: true;
				nextPut: object ] ]
]

{ #category : #initialization }
DataAPI >> initializeWorkingWithin: aContext [

	context := aContext.
	self initializeMappings
]

{ #category : #'private-API' }
DataAPI >> jsonFormattedStreamNamed: aName [

	^ [ self dataManagementSystem
		streamNamed: aName
		ifFound: [ :dataStream | dataStreamMapping value: dataStream ]
		ifNone: [ HTTPClientError signalNotFound ] ]
			on: DataStreamIsEmpty
			do: [ :signal | signal resume: 'N/A' ]
]

{ #category : #'private-API' }
DataAPI >> jsonFormattedStreams [

	^ [ dataStreamsSnapshotsMapping value: self dataManagementSystem streams ]
		on: DataStreamIsEmpty
		do: [ :signal | signal resume: 'N/A' ]
]

{ #category : #API }
DataAPI >> registerBulkPointsHandling: anHttpRequest [

	^ [ | rawData |

	rawData := context decode: anHttpRequest contents encodedAs: anHttpRequest contentType.

	rawData
		do:
			[ :rawDataPoint | context register: (rawDataPoint at: 'value') toStreamNamed: (rawDataPoint at: 'data-stream') ].

	ZnResponse created: 'all' ]
		on: KeyNotFound
		do: [ :signal | 
			HTTPClientError
				signalBadRequest:
					('{"error":{"code":400,"message":"Expected key <1s> was not found"}'
						expandMacrosWith: signal key) ]
]

{ #category : #API }
DataAPI >> registerStreamFrom: aJSON [

	^ [ [ | rawStream name |

	rawStream := (NeoJSONReader on: aJSON readStream)
		propertyNamesAsSymbols: true;
		next.
		
	name := rawStream at: #name.

	self dataManagementSystem registerStreamNamed: name.
	ZnResponse created: (ZnUrl fromString: 'localhost') ]
		on: ConflictingObjectFound
		do: [ :signal | HTTPClientError signalConflict: signal messageText ] ]
		on: KeyNotFound
		do: [ :signal | HTTPClientError signalBadRequest: signal messageText ]
]

{ #category : #API }
DataAPI >> streamNamed: aName [

	^ ZnResponse
		ok: (ZnEntity json: (self jsonFormattedStreamNamed: aName))
]

{ #category : #API }
DataAPI >> streams [

	^ ZnResponse ok:
		(ZnEntity json: self jsonFormattedStreams)
]
