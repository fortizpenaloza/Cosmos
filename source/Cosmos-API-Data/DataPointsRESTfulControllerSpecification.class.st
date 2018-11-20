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

	^ 'application/json;version=1.0.0' asMediaType
]

{ #category : #'specification - routes' }
DataPointsRESTfulControllerSpecification >> createDataPointsRoute [

	^ (RouteSpecification
		handling: #POST
		at: '/data-points'
		sending: #createPointsBasedOn:within:) asCorsAware 
]

{ #category : #'encoders and decoders' }
DataPointsRESTfulControllerSpecification >> dataPointsDecoderVersion1dot0dot0 [

	^ [ :json :context | 	| timestamp |

	timestamp := self timestampFrom: context.
	
	(NeoJSONReader on: json readStream) next
		collect: [ :dataStreamDataPoint | 
			(dataStreamDataPoint at: #data_stream)
				-> (DataPoint on: timestamp holding: (dataStreamDataPoint at: #value)) ] ]
]

{ #category : #'encoders and decoders' }
DataPointsRESTfulControllerSpecification >> timestampFrom: aRequestContext [

	^ aRequestContext
		objectUnder: #request_timestamp
]
