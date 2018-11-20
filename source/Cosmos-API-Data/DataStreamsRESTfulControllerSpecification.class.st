Class {
	#name : #DataStreamsRESTfulControllerSpecification,
	#superclass : #ResourceRESTfulControllerSpecification,
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
		to: self dataStreamsMappingKey
		using: self dataStreamJsonDecoderVersion1dot0dot0
]

{ #category : #'specification - encoders and decoders' }
DataStreamsRESTfulControllerSpecification >> addDataStreamEncoderVersion1dot0dot0MappingIn: aBuilder [

	aBuilder
		addDefaultRuleToEncode: self dataStreamMappingKey
		to: self applicationJsonVersion1dot0dot0MediaType
		using: self dataStreamJsonEncoderVersion1dot0dot0.

	aBuilder
		addDefaultRuleToEncode: self dataStreamsMappingKey
		to: self applicationJsonVersion1dot0dot0MediaType
		using: self dataStreamsJsonEncoderVersion1dot0dot0
]

{ #category : #'media types' }
DataStreamsRESTfulControllerSpecification >> applicationJsonVersion1dot0dot0MediaType [

	^ 'application/json;version=1.0.0' asMediaType
]

{ #category : #'specification - routes' }
DataStreamsRESTfulControllerSpecification >> createDataStreamRoute [

	^ (RouteSpecification
		handling: #POST
		at: self endpoint
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

{ #category : #accessing }
DataStreamsRESTfulControllerSpecification >> dataPointsTemplate [

	^ '<1s>/data-points' expandMacrosWith: self idTemplate
]

{ #category : #'encoders and decoders' }
DataStreamsRESTfulControllerSpecification >> dataStreamJsonDecoderVersion1dot0dot0 [

	^ [ :json | 
	(NeoJSONReader on: json readStream)
		for: DataStream
			customDo: [ :mapping | 
			mapping
				decoder: [ :rawStream | DataStream named: (rawStream at: #name) ] ];
		nextAs: DataStream ]
]

{ #category : #'encoders and decoders' }
DataStreamsRESTfulControllerSpecification >> dataStreamJsonEncoderVersion1dot0dot0 [

	^ [ :dataStream :context | 

	String
		streamContents: [ :stream | 
			(NeoJSONWriter on: stream)
				for: DataStream
					do: [ :mapping | 
					mapping
						mapInstVar: #name;
						mapAccessor: #currentValue to: 'current_value';
						mapAccessor: #lastUpdate to: 'last_update';
						mapHypermediaControlsIn: context];
				for: DateTime
					customDo:
						[ :mapping | mapping encoder: [ :dateTime | ISO8601DateTimeFormatter usingExtendedFormat format: dateTime ] ];
				nextPut: dataStream ] ]
]

{ #category : #accessing }
DataStreamsRESTfulControllerSpecification >> dataStreamMappingKey [

	^ #data_stream
]

{ #category : #'encoders and decoders' }
DataStreamsRESTfulControllerSpecification >> dataStreamsJsonEncoderVersion1dot0dot0 [

	^ [ :dataStreams :context | 
	String
		streamContents: [ :stream | 
			(NeoJSONWriter on: stream)
				for: DataStream
					do: [ :mapping | 
					mapping
						mapInstVar: #name;
						mapAccessor: #currentValue to: 'current_value';
						mapAccessor: #lastUpdate to: 'last_update';
						mapAsHypermediaControls: [ :dataStream | context hypermediaControlsFor: dataStream ] ];
				for: DateTime
					customDo: [ :mapping | 
					mapping
						encoder: [ :dateTime | ISO8601DateTimeFormatter usingExtendedFormat format: dateTime ] ];
				nextPut: dataStreams ] ]
]

{ #category : #accessing }
DataStreamsRESTfulControllerSpecification >> dataStreamsMappingKey [

	^ #data_streams
]

{ #category : #'specification - routes' }
DataStreamsRESTfulControllerSpecification >> deleteDataStreamRoute [

	^ (RouteSpecification
		handling: #DELETE
		at: self idTemplate
		sending: #deleteStreamBasedOn:within:) asCorsAware
]

{ #category : #accessing }
DataStreamsRESTfulControllerSpecification >> endpoint [

	^ '/data-streams'
]

{ #category : #'specification - routes' }
DataStreamsRESTfulControllerSpecification >> getDataPointsRoute [

	^ RouteSpecification
		handling: #GET
		at: self dataPointsTemplate
		sending: #getPointsBasedOn:within:
]

{ #category : #'specification - routes' }
DataStreamsRESTfulControllerSpecification >> getDataStreamRoute [

	^ RouteSpecification
		handling: #GET
		at: self idTemplate
		sending: #getStreamBasedOn:within:
]

{ #category : #'specification - routes' }
DataStreamsRESTfulControllerSpecification >> getDataStreamsRoute [

	^ RouteSpecification
		handling: #GET
		at: self endpoint
		sending: #getStreamsBasedOn:within:
]

{ #category : #accessing }
DataStreamsRESTfulControllerSpecification >> idTemplate [

	^ '<1s>/%<<2s>:IsUUID>' expandMacrosWith: self endpoint with: self identifierKey
]

{ #category : #accessing }
DataStreamsRESTfulControllerSpecification >> identifierKey [

	^ #identifier
]
