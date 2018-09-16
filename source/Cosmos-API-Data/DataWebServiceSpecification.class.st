Class {
	#name : #DataWebServiceSpecification,
	#superclass : #Object,
	#instVars : [
		'server',
		'interface',
		'mappingRuleSetBuilder'
	],
	#category : #'Cosmos-API-Data'
}

{ #category : #'instance creation' }
DataWebServiceSpecification class >> toInstallOn: aServer workingWith: aCosmosSystem [

	^ self new initializeToInstallOn: aServer workingWith: aCosmosSystem
]

{ #category : #'installing - encoders and decoders' }
DataWebServiceSpecification >> addBulkDataPointDecoderVersion1dot0dot0Mapping [

	mappingRuleSetBuilder
		addDefaultRuleToDecode: self bulkDataPointMimeTypeVersion1dot0dot0
		to: #data_points
		using: self bulkDataPointDecoderVersion1dot0dot0
]

{ #category : #routes }
DataWebServiceSpecification >> addCrossOriginResourceSharingRouteXX [

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
DataWebServiceSpecification >> addDataPointEncoderVersion1dot0dot0Mapping [

	mappingRuleSetBuilder
		addDefaultRuleToEncode: #data_points
		to:
			(ZnMimeType
				fromString: 'application/vnd.cosmos.data-points+json; version=1.0.0')
		using: self dataPointJsonEncoderVersion1dot0dot0
]

{ #category : #'installing - encoders and decoders' }
DataWebServiceSpecification >> addDataStreamDecoderVersion1dot0dot0Mapping [

	mappingRuleSetBuilder
		addDefaultRuleToDecode: self applicationJsonVersion1dot0dot0
		to: #data_streams
		using: self dataStreamJsonDecoderVersion1dot0dot0
]

{ #category : #'installing - encoders and decoders' }
DataWebServiceSpecification >> addDataStreamEncoderVersion1dot0dot0Mapping [

	mappingRuleSetBuilder
		addDefaultRuleToEncode: #data_streams
		to: self applicationJsonVersion1dot0dot0 
		using: self dataStreamJsonEncoderVersion1dot0dot0
]

{ #category : #'accessing - media types' }
DataWebServiceSpecification >> applicationJsonVersion1dot0dot0 [

	^ ZnMimeType fromString: 'application/json;version=1.0.0'
]

{ #category : #'encoders and decoders' }
DataWebServiceSpecification >> bulkDataPointDecoderVersion1dot0dot0 [

	^ [ :aJSON | 
	(NeoJSONReader on: aJSON readStream)
		propertyNamesAsSymbols: true;
		next ]
]

{ #category : #'accessing - media types' }
DataWebServiceSpecification >> bulkDataPointMimeTypeVersion1dot0dot0 [

	^ ZnMimeType fromString: 'application/vnd.cosmos.data-point+json; version=1.0.0'
]

{ #category : #routes }
DataWebServiceSpecification >> createBulkDataPointsRoute [

	^ RouteSpecification
		handling: #POST
		at: '/data-points'
		sending: #createBulkPointsBasedOn:within:
]

{ #category : #routes }
DataWebServiceSpecification >> createDataStreamRoute [

	^ RouteSpecification
		handling: #POST
		at: '/data-streams'
		sending: #createStreamBasedOn:within:
]

{ #category : #'encoders and decoders' }
DataWebServiceSpecification >> dataPointJsonEncoderVersion1dot0dot0 [

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
DataWebServiceSpecification >> dataStreamJsonDecoderVersion1dot0dot0 [

	^ [ :aJSON | 
	(NeoJSONReader on: aJSON readStream)
		for: DataStream
			customDo: [ :mapping | 
			mapping
				decoder: [ :rawStream | DataStream named: (rawStream at: #name) ] ];
		nextAs: DataStream ]
]

{ #category : #'encoders and decoders' }
DataWebServiceSpecification >> dataStreamJsonEncoderVersion1dot0dot0 [

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
									put: ((context systemImplementing: #MetadataSystemInterface) metadataFor: dataStream);
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

{ #category : #routes }
DataWebServiceSpecification >> deleteDataStreamRoute [

	^ RouteSpecification
		handling: #DELETE
		at: '/data-streams/<identifier:IsUUID>'
		sending: #deleteStreamBasedOn:within:
]

{ #category : #routes }
DataWebServiceSpecification >> getDataPointsRoute [

	^ RouteSpecification
		handling: #GET
		at: '/data-streams/<identifier:IsUUID>/data-points'
		sending: #getPointsBasedOn:within:
]

{ #category : #routes }
DataWebServiceSpecification >> getDataStreamsRoute [

	^ RouteSpecification
		handling: #GET
		at: '/data-streams/<identifier:IsUUID>'
		sending: #getStreamsBasedOn:within:
]

{ #category : #initialization }
DataWebServiceSpecification >> initializeToInstallOn: aServer workingWith: aCosmosSystem [

	mappingRuleSetBuilder := MappingRuleSetBuilder new.

	self
		addDataStreamDecoderVersion1dot0dot0Mapping;
		addDataStreamEncoderVersion1dot0dot0Mapping;
		addBulkDataPointDecoderVersion1dot0dot0Mapping;
		addDataPointEncoderVersion1dot0dot0Mapping.

	interface := DataWebService
		workingWithin: (DataAPIContext workingWith: aCosmosSystem queryingMappingsTo: mappingRuleSetBuilder build).
		
	server := aServer
]

{ #category : #installing }
DataWebServiceSpecification >> install [

	self
		createDataStreamRoute;
		getDataStreamsRoute;
		deleteDataStreamRoute;	
		getDataPointsRoute;
		createBulkDataPointsRoute;
		addCrossOriginResourceSharingRouteXX.
		
		"GET, POST data-streams/<id>/metadata"
		"GET, POST data-streams/<id>/data-points"

	^ interface
]
