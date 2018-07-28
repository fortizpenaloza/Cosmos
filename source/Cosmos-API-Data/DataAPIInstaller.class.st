Class {
	#name : #DataAPIInstaller,
	#superclass : #Object,
	#instVars : [
		'server',
		'interface',
		'mappingRegistry'
	],
	#category : #'Cosmos-API-Data'
}

{ #category : #'instance creation' }
DataAPIInstaller class >> toInstallOn: aServer workingWith: aCosmosSystem [

	^ self new initializeToInstallOn: aServer workingWith: aCosmosSystem
]

{ #category : #'private-installing' }
DataAPIInstaller >> addBulkDataPointRegistrationRoute [

	server
		POST: '/data-points' -> [ :request | interface registerBulkPointsBasedOn: request contents ];
		output: #text.

	self registerBulkDataPointDecoderVersion1dot0dot0
]

{ #category : #'private-installing' }
DataAPIInstaller >> addCrossOriginResourceSharingRoute [

	server
		OPTIONS:
			'/data-streams'
				-> [ :request | 
					| response |

					response := ZnResponse noContent.

					response headers
						at: 'Access-Control-Allow-Headers' put: 'Access-Control-Allow-Origin, Content-Type, Accept';
						at: 'Access-Control-Allow-Methods' put: 'POST, GET';
						at: 'Access-Control-Max-Age' put: '86400'.

					response ]
]

{ #category : #'private-installing' }
DataAPIInstaller >> addGetDataStreamRoute [

	server
		GET:
			'/data-streams/<name>'
				-> [ :request | interface streamBasedOn: request ].
				
	self registerDataStreamEncoderVersion1dot0dot0
]

{ #category : #'private-installing' }
DataAPIInstaller >> addGetDataStreamSnapshotsRoute [

	server GET: '/data-streams' -> [ :request | interface streamsSummaryBasedOn: request ].
	
	self registerDataStreamSnapshotEncoderVersion1dot0dot0
	
]

{ #category : #'private-installing' }
DataAPIInstaller >> addRegisterDataStreamRoute [

	server
		POST:
			'/data-streams'
				-> [ :request | interface registerStreamBasedOn: request ]
]

{ #category : #accessing }
DataAPIInstaller >> bulkDataPointDecoderVersion1dot0dot0 [

	^ [ :aJSON | 
	(NeoJSONReader on: aJSON readStream)
		propertyNamesAsSymbols: true;
		next ]
]

{ #category : #accessing }
DataAPIInstaller >> bulkDataPointMimeTypeVersion1dot0dot0 [

	^ ZnMimeType fromString: 'application/vnd.cosmos.data-point+json; version=1.0.0'
]

{ #category : #accessing }
DataAPIInstaller >> dataStreamEncoderVersion1dot0dot0 [

	^ [ :dataStream | 
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
				nextPut: dataStream ] ]
]

{ #category : #accessing }
DataAPIInstaller >> dataStreamSnapshotEncoderVersion1dot0dot0 [

	^ [ :dataStream | 
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
				nextPut: dataStream ] ]
]

{ #category : #accessing }
DataAPIInstaller >> dataStreamSnapshotMimeTypeVersion1dot0dot0 [

	^  ZnMimeType fromString: 'application/vnd.cosmos.data-stream-snapshot+json; version=1.0.0'
]

{ #category : #initialization }
DataAPIInstaller >> initializeToInstallOn: aServer workingWith: aCosmosSystem [

	mappingRegistry := MappingRegistry new.
	interface := DataAPI workingWithin: (DataAPIContext workingWith: aCosmosSystem queryingMappingsTo: mappingRegistry).
	server := aServer
]

{ #category : #installing }
DataAPIInstaller >> install [

	self
		addGetDataStreamSnapshotsRoute;
		addGetDataStreamRoute;
		addRegisterDataStreamRoute;
		addBulkDataPointRegistrationRoute;
		addCrossOriginResourceSharingRoute.

	^ interface
]

{ #category : #accessing }
DataAPIInstaller >> registerBulkDataPointDecoderVersion1dot0dot0 [

	mappingRegistry
		register: self bulkDataPointDecoderVersion1dot0dot0
		asDecoderFor: self bulkDataPointMimeTypeVersion1dot0dot0
]

{ #category : #accessing }
DataAPIInstaller >> registerDataStreamEncoderVersion1dot0dot0 [

	mappingRegistry
		register: self dataStreamEncoderVersion1dot0dot0
		asEncoderFor: (ZnMimeType fromString: 'application/vnd.cosmos.data-stream+json; version=1.0.0')
]

{ #category : #accessing }
DataAPIInstaller >> registerDataStreamSnapshotEncoderVersion1dot0dot0 [

	mappingRegistry
		register: self dataStreamSnapshotEncoderVersion1dot0dot0
		asEncoderFor: self dataStreamSnapshotMimeTypeVersion1dot0dot0
]
