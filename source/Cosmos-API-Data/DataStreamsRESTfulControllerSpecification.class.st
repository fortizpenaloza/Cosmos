Class {
	#name : #DataStreamsRESTfulControllerSpecification,
	#superclass : #ResourceRESTFulControllerSpecification,
	#category : #'Cosmos-API-Data'
}

{ #category : #'specification - encoders and decoders' }
DataStreamsRESTfulControllerSpecification >> addDataPointEncoderVersion1dot0dot0MappingIn: aBuilder [

	aBuilder
		addDefaultRuleToEncode: #data_points
		to: self applicationJsonVersion1dot0dot0MediaType 
		using: self dataPointJsonEncoderVersion1dot0dot0
]

{ #category : #'specification - encoders and decoders' }
DataStreamsRESTfulControllerSpecification >> addDataStreamDecoderVersion1dot0dot0MappingIn: aBuilder [

	aBuilder
		addDefaultRuleToDecode: self applicationJsonVersion1dot0dot0MediaType
		to: #data_streams
		using: self dataStreamJsonDecoderVersion1dot0dot0
]

{ #category : #'specification - encoders and decoders' }
DataStreamsRESTfulControllerSpecification >> addDataStreamEncoderVersion1dot0dot0MappingIn: aBuilder [

	aBuilder
		addDefaultRuleToEncode: #data_streams
		to: self applicationJsonVersion1dot0dot0MediaType 
		using: self dataStreamJsonEncoderVersion1dot0dot0
]

{ #category : #'media types' }
DataStreamsRESTfulControllerSpecification >> applicationJsonVersion1dot0dot0MediaType [

	^ 'application/json;version=1.0.0' asZnMimeType
]

{ #category : #'specification - routes' }
DataStreamsRESTfulControllerSpecification >> createDataStreamRoute [

	^ (RouteSpecification
		handling: #POST
		at: '/data-streams'
		sending: #createStreamBasedOn:within:) asCorsAware
]

{ #category : #'encoders and decoders' }
DataStreamsRESTfulControllerSpecification >> dataPointJsonEncoderVersion1dot0dot0 [

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
				nextPut: dataPoint ] ]
]

{ #category : #'encoders and decoders' }
DataStreamsRESTfulControllerSpecification >> dataStreamJsonDecoderVersion1dot0dot0 [

	^ [ :aJSON | 
	(NeoJSONReader on: aJSON readStream)
		for: DataStream
			customDo: [ :mapping | 
			mapping
				decoder: [ :rawStream | DataStream named: (rawStream at: #name) ] ];
		nextAs: DataStream ]
]

{ #category : #'encoders and decoders' }
DataStreamsRESTfulControllerSpecification >> dataStreamJsonEncoderVersion1dot0dot0 [

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
DataStreamsRESTfulControllerSpecification >> deleteDataStreamRoute [

	^ (RouteSpecification
		handling: #DELETE
		at: '/data-streams/<identifier:IsUUID>'
		sending: #deleteStreamBasedOn:within:) asCorsAware 
]

{ #category : #'specification - routes' }
DataStreamsRESTfulControllerSpecification >> getDataPointsRoute [

	^ RouteSpecification
		handling: #GET
		at: '/data-streams/<identifier:IsUUID>/data-points'
		sending: #getPointsBasedOn:within:
]

{ #category : #'specification - routes' }
DataStreamsRESTfulControllerSpecification >> getDataStreamRoute [

	^ RouteSpecification
		handling: #GET
		at: '/data-streams/<identifier:IsUUID>'
		sending: #getStreamBasedOn:within:
]

{ #category : #'specification - routes' }
DataStreamsRESTfulControllerSpecification >> getDataStreamsRoute [

	^ RouteSpecification
		handling: #GET
		at: '/data-streams'
		sending: #getStreamsBasedOn:within:
]
