Class {
	#name : #DataPointsRESTfulControllerSpecification,
	#superclass : #ResourceRESTfulControllerSpecification,
	#category : #'Cosmos-API-Data'
}

{ #category : #'specification - encoders and decoders' }
DataPointsRESTfulControllerSpecification >> addDataPointsDecoderVersion1dot0dot0MappingIn: aBuilder [

	aBuilder
		addDefaultRuleToDecode: self applicationJsonVersion1dot0dot0MediaType 
		to: #data_points
		using: self dataPointsDecoderVersion1dot0dot0
]

{ #category : #'specification - encoders and decoders' }
DataPointsRESTfulControllerSpecification >> applicationJsonVersion1dot0dot0MediaType [

	^ 'application/json;version=1.0.0' asZnMimeType
]

{ #category : #'specification - routes' }
DataPointsRESTfulControllerSpecification >> createDataPointsRoute [

	^ RouteSpecification
		handling: #POST
		at: '/data-points'
		sending: #createPointsBasedOn:within:
]

{ #category : #'encoders and decoders' }
DataPointsRESTfulControllerSpecification >> dataPointsDecoderVersion1dot0dot0 [

	^ [ :aJson :context | 
	| timestamp |

	timestamp := self timestampFrom: context.

	(NeoJSONReader on: aJson readStream)
		for: #ArrayOfAssociations
			customDo: [ :mapping | mapping listOfElementSchema: Association ];
		for: Association
			do: [ :mapping | 
			mapping mapInstVar: #key to: #data_stream.
			(mapping mapInstVar: #value) valueSchema: DataPoint ];
		for: DataPoint
			customDo: [ :mapping | mapping decoder: [ :value | DataPoint on: timestamp holding: value ] ];
		nextAs: #ArrayOfAssociations ]
]

{ #category : #'encoders and decoders' }
DataPointsRESTfulControllerSpecification >> timestampFrom: aRequestContext [

	^ aRequestContext
		objectUnder: #request_timestamp
		ifNone: [ DecodingFailed signal: 'Request timestamp not found in context' ]
]
