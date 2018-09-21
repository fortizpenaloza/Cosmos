Class {
	#name : #ActionsWebServiceSpecification,
	#superclass : #Object,
	#category : #'Cosmos-API-Actions'
}

{ #category : #'encoders and decoders' }
ActionsWebServiceSpecification >> actionJsonDecoderVersion1dot0dot0 [

	^ [ :aJSON | 
	(NeoJSONReader on: aJSON readStream)
		for: Action
			customDo: [ :mapping | 
			mapping
				decoder: [ :rawAction | 
					Action
						named: (rawAction at: #name)
						evaluating:
							(SendHttpRequestPolicy
								sending: (HTTPRequestParser new parse: (rawAction at: #http_request))) ] ];
		nextAs: Action ]
]

{ #category : #'encoders and decoders' }
ActionsWebServiceSpecification >> actionJsonEncoderVersion1dot0dot0 [

	^ [ :action | 
	String
		streamContents: [ :stream | 
			(NeoJSONWriter on: stream)
				for: Action
					do: [ :mapping | 
					mapping mapInstVar: #name.
					(mapping mapInstVar: #evaluationPolicy to: #http_request) valueSchema: #Policy ];
				for: #Policy
				customDo: [ :mapping | mapping encoder: [ :a | a instVarAt: 1 ]   ];
				for: ZnRequest
					do: [ :mapping | 
					mapping
						mapAccessor: #requestLine to: #request_line;
						mapAccessor: #headers;
						mapAccessor: #entity ];
				for: ZnRequestLine
					do: [ :mapping | 
					mapping
						mapAccessor: #method;
						mapAccessor: #uri to: #url;
						mapInstVar: #version ];
				for: ZnUrl customDo: [ :mapping | mapping encoder: [ :url | url printString ] ];
				for: ZnHeaders
					customDo: [ :mapping | mapping encoder: [ :headers | headers headers associations ] ];
				for: Association
					do: [ :mapping | 
					mapping
						mapAccessor: #key;
						mapAccessor: #value ];
				for: DateTime
					customDo:
						[ :mapping | mapping encoder: [ :dateTime | ISO8601DateTimeFormatter usingExtendedFormat format: dateTime ] ];
				nextPut: action ] ]
]

{ #category : #'specification - encoders and decoders' }
ActionsWebServiceSpecification >> addActionJsonDecoderVersion1dot0dot0MappingIn: aBuilder [

	aBuilder
		addDefaultRuleToDecode: self applicationJsonVersion1dot0dot0
		to: #actions
		using: self actionJsonDecoderVersion1dot0dot0
]

{ #category : #'specification - encoders and decoders' }
ActionsWebServiceSpecification >> addActionJsonEncoderVersion1dot0dot0MappingIn: aBuilder [

	aBuilder
		addDefaultRuleToEncode: #actions
		to: self applicationJsonVersion1dot0dot0 
		using: self actionJsonEncoderVersion1dot0dot0
]

{ #category : #'media types' }
ActionsWebServiceSpecification >> applicationJsonVersion1dot0dot0 [

	^ ZnMimeType fromString: 'application/json;version=1.0.0'
]

{ #category : #'specification - routes' }
ActionsWebServiceSpecification >> createActionRoute [

	^ RouteSpecification handling: #POST at: '/actions' sending: #registerHandling:
]

{ #category : #'specification - routes' }
ActionsWebServiceSpecification >> deleteActionRoute [

	^ RouteSpecification handling: #DELETE at: '/actions/<name>' sending: #deregisterNamed:
]

{ #category : #'specification - routes' }
ActionsWebServiceSpecification >> getActionsRoute [

	^ RouteSpecification handling: #GET at: '/actions' sending: #getActionsBasedOn:within:
]
