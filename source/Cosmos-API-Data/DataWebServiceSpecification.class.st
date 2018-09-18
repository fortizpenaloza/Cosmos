Class {
	#name : #DataWebServiceSpecification,
	#superclass : #Object,
	#category : #'Cosmos-API-Data'
}

{ #category : #'specification - encoders and decoders' }
DataWebServiceSpecification >> addBulkDataPointDecoderVersion1dot0dot0MappingIn: aBuilder [

	aBuilder
		addDefaultRuleToDecode: self applicationJsonVersion1dot0dot0 
		to: #data_points
		using: self bulkDataPointDecoderVersion1dot0dot0
]

{ #category : #'specification - encoders and decoders' }
DataWebServiceSpecification >> addDataPointEncoderVersion1dot0dot0MappingIn: aBuilder [

	aBuilder
		addDefaultRuleToEncode: #data_points
		to:
			(ZnMimeType
				fromString: 'application/vnd.cosmos.data-points+json; version=1.0.0')
		using: self dataPointJsonEncoderVersion1dot0dot0
]

{ #category : #'specification - encoders and decoders' }
DataWebServiceSpecification >> addDataStreamDecoderVersion1dot0dot0MappingIn: aBuilder [

	aBuilder
		addDefaultRuleToDecode: self applicationJsonVersion1dot0dot0
		to: #data_streams
		using: self dataStreamJsonDecoderVersion1dot0dot0
]

{ #category : #'specification - encoders and decoders' }
DataWebServiceSpecification >> addDataStreamEncoderVersion1dot0dot0MappingIn: aBuilder [

	aBuilder
		addDefaultRuleToEncode: #data_streams
		to: self applicationJsonVersion1dot0dot0 
		using: self dataStreamJsonEncoderVersion1dot0dot0
]

{ #category : #'media types' }
DataWebServiceSpecification >> applicationJsonVersion1dot0dot0 [

	^ ZnMimeType fromString: 'application/json;version=1.0.0'
]

{ #category : #'encoders and decoders' }
DataWebServiceSpecification >> bulkDataPointDecoderVersion1dot0dot0 [

	^ [ :aJSON :context | | timestamp |

	timestamp := context objectUnder: #request_timestamp ifNone: [ self halt ].

	(NeoJSONReader on: aJSON readStream)
		for: #ArrayOfPair customDo: [ :mapping | mapping listOfElementSchema: Association ];
		for: Association
			do: [ :mapping | 
			mapping mapInstVar: #key to: #data_stream.
			(mapping mapInstVar: #value) valueSchema: DataPoint ];
		for: DataPoint
			customDo: [ :mapping | mapping decoder: [ :value | DataPoint on: timestamp holding: value ] ];
		nextAs: #ArrayOfPair ]
]

{ #category : #'specification - routes' }
DataWebServiceSpecification >> createBulkDataPointsRoute [

	^ RouteSpecification
		handling: #POST
		at: '/data-points'
		sending: #createBulkPointsBasedOn:within:
]

{ #category : #'specification - routes' }
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

	^ [ :dataStreams :context | | metadataSystem |
	
	metadataSystem := context objectUnder: #metadata_system ifNone: [ self halt ].

	String
		streamContents: [ :stream | 
			(NeoJSONWriter on: stream)
				for: DataStream
					customDo: [ :mapping | 
					mapping
						encoder: [ :dataStream | 
							OrderedDictionary new
								at: 'name' put: dataStream name;
								at: 'current_value' put: dataStream currentValue;
								at: 'last_update' put: dataStream lastUpdate;
								at: 'metadata' put: (metadataSystem metadataFor: dataStream);
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

{ #category : #'specification - routes' }
DataWebServiceSpecification >> deleteDataStreamRoute [

	^ RouteSpecification
		handling: #DELETE
		at: '/data-streams/<identifier:IsUUID>'
		sending: #deleteStreamBasedOn:within:
]

{ #category : #'specification - routes' }
DataWebServiceSpecification >> getDataPointsRoute [

	^ RouteSpecification
		handling: #GET
		at: '/data-streams/<identifier:IsUUID>/data-points'
		sending: #getPointsBasedOn:within:
]

{ #category : #'specification - routes' }
DataWebServiceSpecification >> getDataStreamsRoute [

	^ RouteSpecification
		handling: #GET
		at: '/data-streams/<identifier:IsUUID>'
		sending: #getStreamsBasedOn:within:
]
