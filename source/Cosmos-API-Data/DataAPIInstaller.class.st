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

{ #category : #'installing - routes' }
DataAPIInstaller >> addCreateBulkDataPointsRoute [

	server
		POST: '/data-points' -> [ :request | interface createBulkPointsBasedOn: request ];
		output: #text
]

{ #category : #'installing - routes' }
DataAPIInstaller >> addCreateDataStreamRoute [

	server
		POST:
			'/data-streams'
				-> [ :request | interface createStreamBasedOn: request ]
]

{ #category : #'installing - routes' }
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

{ #category : #'installing - encoders and decoders' }
DataAPIInstaller >> addDataStreamDecoderVersion1dot0dot0Mapping [

	mappingRuleSetBuilder
		addDefaultRuleToDecode: self applicationJsonVersion1dot0dot0
		to: #data_streams
		using: self dataStreamDecoderVersion1dot0dot0
]

{ #category : #'installing - encoders and decoders' }
DataAPIInstaller >> addDataStreamEncoderVersion1dot0dot0Mapping [

	mappingRuleSetBuilder
		addDefaultRuleToEncode: #data_streams
		to: self applicationJsonVersion1dot0dot0 
		using: self dataStreamEncoderVersion1dot0dot0
]

{ #category : #'installing - routes' }
DataAPIInstaller >> addDeleteDataStreamRoute [

	server
		DELETE:
			'/data-streams/<identifier:IsUUID>'
				-> [ :request | interface deleteStreamBasedOn: request ]
]

{ #category : #'installing - routes' }
DataAPIInstaller >> addGetDataPointsRoute [

	server
		GET:
			'/data-streams/<identifier:IsUUID>/data-points'
				-> [ :request | interface getPointsBasedOn: request ]
]

{ #category : #'installing - routes' }
DataAPIInstaller >> addGetDataStreamsRoute [

	server
		GET:
			'/data-streams/<identifier:IsUUID>'
				-> [ :request | interface getStreamsBasedOn: request ]
]

{ #category : #'media types' }
DataAPIInstaller >> applicationJsonVersion1dot0dot0 [

	^ ZnMimeType fromString: 'application/json;version=1.0.0'
]

{ #category : #'encoders and decoders' }
DataAPIInstaller >> bulkDataPointDecoderVersion1dot0dot0 [

	^ [ :aJSON | 
	(NeoJSONReader on: aJSON readStream)
		propertyNamesAsSymbols: true;
		next ]
]

{ #category : #'media types' }
DataAPIInstaller >> bulkDataPointMimeTypeVersion1dot0dot0 [

	^ ZnMimeType fromString: 'application/vnd.cosmos.data-point+json; version=1.0.0'
]

{ #category : #'encoders and decoders' }
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

{ #category : #'encoders and decoders' }
DataAPIInstaller >> dataStreamDecoderVersion1dot0dot0 [

	^ [ :aJSON | 
	(NeoJSONReader on: aJSON readStream)
		for: DataStream
			customDo: [ :mapping | 
			mapping
				decoder: [ :rawStream | DataStream named: (rawStream at: #name) ] ];
		nextAs: DataStream ]
]

{ #category : #'encoders and decoders' }
DataAPIInstaller >> dataStreamEncoderVersion1dot0dot0 [

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
								at: 'metadata' put: (context metadataSystem metadataFor: dataStream);
								yourself ] ];
				for: Metadata
					customDo: [ :mapping | 
					mapping
						encoder: [ :metadata | 
							Dictionary new
								at: metadata aspect put: metadata data;
								yourself ] ];
				for: DateTime
					customDo: [ :mapping | 
					mapping
						encoder: [ :dateTime | ISO8601DateTimeFormatter usingExtendedFormat format: dateTime ] ];
				nextPut: dataStreams ] ]
]

{ #category : #initialization }
DataAPIInstaller >> initializeToInstallOn: aServer workingWith: aCosmosSystem [

	mappingRuleSetBuilder := MappingRuleSetBuilder new.

	self
		addDataStreamDecoderVersion1dot0dot0Mapping;
		addDataStreamEncoderVersion1dot0dot0Mapping;
		registerBulkDataPointDecoderVersion1dot0dot0;
		registerDataPointEncoderVersion1dot0dot0.

	interface := DataAPI
		workingWithin: (DataAPIContext workingWith: aCosmosSystem queryingMappingsTo: mappingRuleSetBuilder build).
		
	server := aServer
]

{ #category : #installing }
DataAPIInstaller >> install [

	self
		addCreateDataStreamRoute;
		addGetDataStreamsRoute;
		addDeleteDataStreamRoute;	
		addGetDataPointsRoute;
		addCreateBulkDataPointsRoute;
		addCrossOriginResourceSharingRoute.
		
		"GET, POST data-streams/<id>/metadata"
		"GET, POST data-streams/<id>/data-points"

	^ interface
]

{ #category : #'installing - encoders and decoders' }
DataAPIInstaller >> registerBulkDataPointDecoderVersion1dot0dot0 [

	mappingRuleSetBuilder
		addDefaultRuleToDecode: self bulkDataPointMimeTypeVersion1dot0dot0
		to: #data_points
		using: self bulkDataPointDecoderVersion1dot0dot0
]

{ #category : #'installing - encoders and decoders' }
DataAPIInstaller >> registerDataPointEncoderVersion1dot0dot0 [

	mappingRuleSetBuilder
		addDefaultRuleToEncode: #data_points
		to:
			(ZnMimeType
				fromString: 'application/vnd.cosmos.data-points+json; version=1.0.0')
		using: self dataPointEncoderVersion1dot0dot0
]
