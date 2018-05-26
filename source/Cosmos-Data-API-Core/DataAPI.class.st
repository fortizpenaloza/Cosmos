Class {
	#name : #DataAPI,
	#superclass : #Object,
	#instVars : [
		'rootSystem',
		'dataStreamMapping',
		'dataStreamsSnapshotsMapping'
	],
	#category : 'Cosmos-Data-API-Core'
}

{ #category : #'instance creation' }
DataAPI class >> workingWith: aCompositeSystem [ 
	
	^self new initializeWorkingWith: aCompositeSystem 
]

{ #category : #systems }
DataAPI >> dataManagementSystem [

	^ rootSystem systemImplementing: #DataManagementSystemInterface
]

{ #category : #'initialize-release' }
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

{ #category : #'initialize-release' }
DataAPI >> initializeWorkingWith: aCompositeSystem [

	rootSystem := aCompositeSystem.
	self initializeMappings
]

{ #category : #'private-API' }
DataAPI >> jsonFormattedStreamNamed: aName [

	^ [ self dataManagementSystem
		streamNamed: aName
		ifFound: [ :dataStream | dataStreamMapping value: dataStream ]
		ifNone: [ HTTPClientError signalNotFound ] ]
			on: BindingNotYetDefined
			do: [ :signal | signal resume: 'N/A' ]
]

{ #category : #'private-API' }
DataAPI >> jsonFormattedStreams [

	^ [ dataStreamsSnapshotsMapping value: self dataManagementSystem streams ]
		on: BindingNotYetDefined
		do: [ :signal | signal resume: 'N/A' ]
]

{ #category : #'private-API' }
DataAPI >> register: aValue toStreamNamed: aName [

	^ self dataManagementSystem register: aValue toStreamNamed: aName
]

{ #category : #API }
DataAPI >> registerBulkPointsFrom: aJSON [

	^ [ | rawData |

	rawData := (NeoJSONReader on: aJSON readStream)
		propertyNamesAsSymbols: true;
		next.

	rawData
		do:
			[ :rawDataPoint | self register: (rawDataPoint at: 'value') toStreamNamed: (rawDataPoint at: 'data-stream') ].

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
		on: ObjectAlreadyInSystem
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
