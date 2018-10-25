Class {
	#name : #DataStreamsRESTfulWebServiceSpecification,
	#superclass : #RESTFulWebServiceSpecification,
	#category : #'Cosmos-API-Data'
}

{ #category : #'specification - encoders and decoders' }
DataStreamsRESTfulWebServiceSpecification >> addDataPointEncoderVersion1dot0dot0MappingIn: aBuilder [

	aBuilder
		addDefaultRuleToEncode: #data_points
		to: self applicationJsonVersion1dot0dot0 
		using: self dataPointJsonEncoderVersion1dot0dot0
]

{ #category : #'specification - encoders and decoders' }
DataStreamsRESTfulWebServiceSpecification >> addDataStreamDecoderVersion1dot0dot0MappingIn: aBuilder [

	aBuilder
		addDefaultRuleToDecode: self applicationJsonVersion1dot0dot0
		to: #data_streams
		using: self dataStreamJsonDecoderVersion1dot0dot0
]

{ #category : #'specification - encoders and decoders' }
DataStreamsRESTfulWebServiceSpecification >> addDataStreamEncoderVersion1dot0dot0MappingIn: aBuilder [

	aBuilder
		addDefaultRuleToEncode: #data_streams
		to: self applicationJsonVersion1dot0dot0 
		using: self dataStreamJsonEncoderVersion1dot0dot0
]

{ #category : #'media types' }
DataStreamsRESTfulWebServiceSpecification >> applicationJsonVersion1dot0dot0 [

	^ 'application/json;version=1.0.0' asZnMimeType
]

{ #category : #'specification - routes' }
DataStreamsRESTfulWebServiceSpecification >> createDataStreamRoute [

	^ (RouteSpecification
		handling: #POST
		at: '/data-streams'
		sending: #createStreamBasedOn:within:) asCorsAware
]

{ #category : #'encoders and decoders' }
DataStreamsRESTfulWebServiceSpecification >> dataPointJsonEncoderVersion1dot0dot0 [

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
DataStreamsRESTfulWebServiceSpecification >> dataStreamJsonDecoderVersion1dot0dot0 [

	^ [ :aJSON | 
	(NeoJSONReader on: aJSON readStream)
		for: DataStream
			customDo: [ :mapping | 
			mapping
				decoder: [ :rawStream | DataStream named: (rawStream at: #name) ] ];
		nextAs: DataStream ]
]

{ #category : #'encoders and decoders' }
DataStreamsRESTfulWebServiceSpecification >> dataStreamJsonEncoderVersion1dot0dot0 [

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
DataStreamsRESTfulWebServiceSpecification >> deleteDataStreamRoute [

	^ (RouteSpecification
		handling: #DELETE
		at: '/data-streams/<identifier:IsUUID>'
		sending: #deleteStreamBasedOn:within:) asCorsAware 
]

{ #category : #'specification - routes' }
DataStreamsRESTfulWebServiceSpecification >> getDataPointsRoute [

	^ RouteSpecification
		handling: #GET
		at: '/data-streams/<identifier:IsUUID>/data-points'
		sending: #getPointsBasedOn:within:
]

{ #category : #'specification - routes' }
DataStreamsRESTfulWebServiceSpecification >> getDataStreamRoute [

	^ RouteSpecification
		handling: #GET
		at: '/data-streams/<identifier:IsUUID>'
		sending: #getStreamBasedOn:within:
]

{ #category : #'specification - routes' }
DataStreamsRESTfulWebServiceSpecification >> getDataStreamsRoute [

	^ RouteSpecification
		handling: #GET
		at: '/data-streams'
		sending: #getStreamsBasedOn:within:
]
