Class {
	#name : #DataAPIInstaller,
	#superclass : #Object,
	#instVars : [
		'server',
		'interface',
		'mappingRuleSetBuilder'
	],
	#category : #'Cosmos-API-Data'
}

{ #category : #'instance creation' }
DataAPIInstaller class >> toInstallOn: aServer workingWith: aCosmosSystem [

	^ self new initializeToInstallOn: aServer workingWith: aCosmosSystem
]

{ #category : #'private - installing' }
DataAPIInstaller >> addCreateBulkDataPointsRoute [

	server
		POST: '/data-points' -> [ :request | interface createBulkPointsBasedOn: request ];
		output: #text
]

{ #category : #'private - installing' }
DataAPIInstaller >> addCreateDataStreamRoute [

	server
		POST:
			'/data-streams'
				-> [ :request | interface createStreamBasedOn: request ]
]

{ #category : #'private - installing' }
DataAPIInstaller >> addCrossOriginResourceSharingRoute [

	server
		OPTIONS:
			'/data-streams'
				-> [ :request | 
					| response |

					response := ZnResponse noContent.

					response headers
						at: 'Access-Control-Allow-Headers' put: 'Access-Control-Allow-Origin, Content-Type, Accept';
						at: 'Access-Control-Allow-Methods' put: 'POST, GET, DELETE, PUT';
						at: 'Access-Control-Max-Age' put: '86400'.

					response ]
]

{ #category : #'private - installing' }
DataAPIInstaller >> addDeleteDataStreamRoute [

	server
		DELETE:
			'/data-streams/<identifier:IsUUID>'
				-> [ :request | interface deleteStreamBasedOn: request ]
]

{ #category : #'private - installing' }
DataAPIInstaller >> addGetDataPointsRoute [

	server
		GET:
			'/data-streams/<identifier:IsUUID>/data-points'
				-> [ :request | interface getPointsBasedOn: request ]
]

{ #category : #'private - installing' }
DataAPIInstaller >> addGetDataStreamRoute [

	server
		GET:
			'/data-streams/<identifier:IsUUID>'
				-> [ :request | interface getStreamBasedOn: request ]
]

{ #category : #'private - installing' }
DataAPIInstaller >> addGetDataStreamSnapshotsRoute [

	server
		GET: '/data-streams' -> [ :request | interface getStreamsSnapshotsBasedOn: request ]
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
DataAPIInstaller >> dataPointEncoderVersion1dot0dot0 [

	^ [ :dataPoint | 
	String
		streamContents: [ :stream | 
			(NeoJSONWriter on: stream)
				for: DataPoint
					do: [ :mapping | 
					mapping
						mapAccessor: #timestamp;
						mapAccessor: #value ];
				for: DateTime
					customDo: [ :mapping | 
					mapping
						encoder:
							[ :dateTime | ISO8601DateTimeFormatter usingExtendedFormat format: dateTime ] ];
				prettyPrint: true;
				nextPut: dataPoint ] ]
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
DataAPIInstaller >> dataStreamMimeTypeVersion1dot0dot0 [

	^ ZnMimeType
		fromString: 'application/vnd.cosmos.data-stream+json; version=1.0.0'
]

{ #category : #accessing }
DataAPIInstaller >> dataStreamSnapshotEncoderVersion1dot0dot0 [

	^ [ :dataStreams :context | 
	String
		streamContents: [ :stream | 
			(NeoJSONWriter on: stream)
				for: DataStream
					customDo: [ :mapping | 
					mapping
						encoder: [ :dataStream | 
							OrderedDictionary new
								at: 'name' put: dataStream name;
								at: 'current-value' put: dataStream currentValue;
								at: 'last-update' put: dataStream lastUpdate;
								at: 'metadata'
									put: (context metadataSystem metadataFor: dataStream);
								yourself ] ];
				for: Metadata
					customDo: [ :mapping | 
					mapping
						encoder: [ :metadata | 
							Dictionary new
								at: metadata aspect put: metadata value;
								yourself ] ];
				for: DateTime
					customDo: [ :mapping | 
					mapping
						encoder:
							[ :dateTime | ISO8601DateTimeFormatter usingExtendedFormat format: dateTime ] ];
				prettyPrint: true;
				nextPut: dataStreams ] ]
]

{ #category : #accessing }
DataAPIInstaller >> dataStreamSnapshotMimeTypeVersion1dot0dot0 [

	^  ZnMimeType fromString: 'application/vnd.cosmos.data-stream-snapshot+json; version=1.0.0'
]

{ #category : #initialization }
DataAPIInstaller >> initializeToInstallOn: aServer workingWith: aCosmosSystem [

	mappingRuleSetBuilder := MappingRuleSetBuilder new.

	self
		registerBulkDataPointDecoderVersion1dot0dot0;
		registerDataStreamSnapshotEncoderVersion1dot0dot0;
		registerDataStreamEncoderVersion1dot0dot0;
		registerDataPointEncoderVersion1dot0dot0.

	interface := DataAPI
		workingWithin: (DataAPIContext workingWith: aCosmosSystem queryingMappingsTo: mappingRuleSetBuilder build).
		
	server := aServer
]

{ #category : #installing }
DataAPIInstaller >> install [

	self
		addGetDataStreamSnapshotsRoute;
		addGetDataStreamRoute;
		addGetDataPointsRoute;
		addCreateDataStreamRoute;
		addDeleteDataStreamRoute;
		addCreateBulkDataPointsRoute;
		addCrossOriginResourceSharingRoute.
		
		"GET, POST data-streams/<id>/metadata"
		"GET, POST data-streams/<id>/data-points"

	^ interface
]

{ #category : #accessing }
DataAPIInstaller >> registerBulkDataPointDecoderVersion1dot0dot0 [

	mappingRuleSetBuilder
		addDefaultRuleToDecode: self bulkDataPointMimeTypeVersion1dot0dot0
		to: #data_points
		using: self bulkDataPointDecoderVersion1dot0dot0
]

{ #category : #accessing }
DataAPIInstaller >> registerDataPointEncoderVersion1dot0dot0 [

	mappingRuleSetBuilder
		addDefaultRuleToEncode: #data_points
		to:
			(ZnMimeType
				fromString: 'application/vnd.cosmos.data-points+json; version=1.0.0')
		using: self dataPointEncoderVersion1dot0dot0
]

{ #category : #accessing }
DataAPIInstaller >> registerDataStreamEncoderVersion1dot0dot0 [

	mappingRuleSetBuilder
		addDefaultRuleToEncode: #data_streams
		to: self dataStreamMimeTypeVersion1dot0dot0
		using: self dataStreamEncoderVersion1dot0dot0
]

{ #category : #accessing }
DataAPIInstaller >> registerDataStreamSnapshotEncoderVersion1dot0dot0 [

	mappingRuleSetBuilder
		addRuleToEncode: #data_streams
		to: self dataStreamSnapshotMimeTypeVersion1dot0dot0
		using: self dataStreamSnapshotEncoderVersion1dot0dot0
]
