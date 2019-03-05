Class {
	#name : #ActionEvaluationSummariesRESTfulControllerSpecification,
	#superclass : #ResourceRESTfulControllerSpecification,
	#category : #'Cosmos-API-Actions'
}

{ #category : #'encoders and decoders' }
ActionEvaluationSummariesRESTfulControllerSpecification >> actionEvaluationSummariesJsonEncoderVersion1dot0dot0 [

	^ [ :actionEvaluationSummaries :context | 
	String
		streamContents: [ :stream | 
			(NeoJSONWriter on: stream)
				for: ActionEvaluationSummary
					do: [ :mapping | 
					mapping
						mapAccessor: #action;
						mapAccessor: #lastEvaluation;
						mapAccessor: #evaluationCount ];
				for: Action do: [ :mapping | mapping mapAccessor: #name ];
				for: DateTime
					customDo: [ :mapping | 
					mapping
						encoder:
							[ :dateTime | ISO8601DateTimeFormatter usingExtendedFormat format: dateTime ] ];
				nextPut: actionEvaluationSummaries ] ]
]

{ #category : #accessing }
ActionEvaluationSummariesRESTfulControllerSpecification >> actionEvaluationSummariesMappingKey [

	^ #actionEvaluationSummaries
]

{ #category : #'specification - encoders and decoders' }
ActionEvaluationSummariesRESTfulControllerSpecification >> addActionEvaluationSummariesJsonEncoderVersion1dot0dot0MappingIn: aBuilder [
		
	aBuilder
		addDefaultRuleToEncode: self actionEvaluationSummariesMappingKey
		to: self applicationJsonVersion1dot0dot0MediaType 
		using: self actionEvaluationSummariesJsonEncoderVersion1dot0dot0
	
]

{ #category : #'media types' }
ActionEvaluationSummariesRESTfulControllerSpecification >> applicationJsonVersion1dot0dot0MediaType [

	^ 'application/json;version=1.0.0' asMediaType
]

{ #category : #accessing }
ActionEvaluationSummariesRESTfulControllerSpecification >> endpoint [

	^ '/actions/evaluation-summaries'
]

{ #category : #'specification - routes' }
ActionEvaluationSummariesRESTfulControllerSpecification >> getActionEvaluationSummariesRoute [

	^ RouteSpecification
		handling: #GET
		at: self endpoint
		sending: #getActionEvaluationSummariesBasedOn:within:
]
