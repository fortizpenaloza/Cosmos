Class {
	#name : #ActionEvaluationsRESTfulControllerSpecification,
	#superclass : #ResourceRESTfulControllerSpecification,
	#category : #'Cosmos-API-Actions'
}

{ #category : #'encoders and decoders' }
ActionEvaluationsRESTfulControllerSpecification >> actionEvaluationSummariesJsonEncoderVersion1dot0dot0 [

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
ActionEvaluationsRESTfulControllerSpecification >> actionEvaluationSummariesMappingKey [

	^ #actionEvaluationsSummary
]

{ #category : #accessing }
ActionEvaluationsRESTfulControllerSpecification >> actionEvaluationSummariesTemplate [

	^ '<1s>/summaries'
		expandMacrosWith: self endpoint
]

{ #category : #'encoders and decoders' }
ActionEvaluationsRESTfulControllerSpecification >> actionEvaluationsJsonEncoderVersion1dot0dot0 [

	^ [ :actionEvaluations :context | 
	String
		streamContents: [ :stream | 
			(NeoJSONWriter on: stream)
				for: ActionEvaluation
					do: [ :mapping | 
					mapping
						mapAccessor: #action;
						mapAccessor: #evaluationDateTime ];
				for: Action do: [ :mapping | mapping mapAccessor: #name ];
				for: DateTime
					customDo: [ :mapping | 
					mapping
						encoder:
							[ :dateTime | ISO8601DateTimeFormatter usingExtendedFormat format: dateTime ] ];
				nextPut: actionEvaluations ] ]
]

{ #category : #accessing }
ActionEvaluationsRESTfulControllerSpecification >> actionEvaluationsMappingKey [
	
	^ #actionEvaluationsMappingKey
]

{ #category : #accessing }
ActionEvaluationsRESTfulControllerSpecification >> actionEvaluationsTemplate [

	^ '<1s>/last'
		expandMacrosWith: self endpoint
]

{ #category : #'specification - encoders and decoders' }
ActionEvaluationsRESTfulControllerSpecification >> addActionEvaluationSummariesJsonEncoderVersion1dot0dot0MappingIn: aBuilder [
		
	aBuilder
		addDefaultRuleToEncode: self actionEvaluationSummariesMappingKey
		to: self applicationJsonVersion1dot0dot0MediaType 
		using: self actionEvaluationSummariesJsonEncoderVersion1dot0dot0
	
]

{ #category : #'specification - encoders and decoders' }
ActionEvaluationsRESTfulControllerSpecification >> addActionEvaluationsJsonEncoderVersion1dot0dot0MappingIn: aBuilder [
		
	aBuilder
		addDefaultRuleToEncode: self actionEvaluationsMappingKey
		to: self applicationJsonVersion1dot0dot0MediaType 
		using: self actionEvaluationsJsonEncoderVersion1dot0dot0
	
]

{ #category : #'media types' }
ActionEvaluationsRESTfulControllerSpecification >> applicationJsonVersion1dot0dot0MediaType [

	^ 'application/json;version=1.0.0' asMediaType
]

{ #category : #accessing }
ActionEvaluationsRESTfulControllerSpecification >> endpoint [

	^ '/action-evaluations'
]

{ #category : #'specification - routes' }
ActionEvaluationsRESTfulControllerSpecification >> getActionEvaluationSummariesRoute [

	^ RouteSpecification
		handling: #GET
		at: self actionEvaluationSummariesTemplate
		sending: #getActionEvaluationSummariesBasedOn:within:
]

{ #category : #'specification - routes' }
ActionEvaluationsRESTfulControllerSpecification >> getActionEvaluationsRoute [

	^ RouteSpecification
		handling: #GET
		at: self actionEvaluationsTemplate
		sending: #getActionEvaluationsBasedOn:within:
]
