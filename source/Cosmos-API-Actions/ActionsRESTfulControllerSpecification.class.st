Class {
	#name : #ActionsRESTfulControllerSpecification,
	#superclass : #ResourceRESTfulControllerSpecification,
	#category : #'Cosmos-API-Actions'
}

{ #category : #'encoders and decoders' }
ActionsRESTfulControllerSpecification >> actionJsonDecoderVersion1dot0dot0 [

	^ [ :json | 
	(NeoJSONReader on: json readStream)
		for: Action
			customDo: [ :mapping | 
			mapping
				decoder: [ :rawAction | 
					Action
						named: (rawAction at: #name)
						evaluating:
							(SendHttpRequestPolicy
								sending: (HTTPRequestDecoder new decode: (rawAction at: #http_request))) ] ];
		nextAs: Action ]
]

{ #category : #'encoders and decoders' }
ActionsRESTfulControllerSpecification >> actionJsonEncoderVersion1dot0dot0 [

	^ [ :action :context | 
	String
		streamContents: [ :stream | 
			(NeoJSONWriter on: stream)
				for: Action
					do: [ :mapping | 
					mapping mapInstVar: #name.
					(mapping mapInstVar: #evaluationPolicy to: #http_request) valueSchema: #Policy.
					mapping mapHypermediaControlsIn: context ];
				for: #Policy
					customDo: [ :mapping | mapping encoder: [ :policy | policy instVarNamed: #requestToSend ] ];
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

{ #category : #accessing }
ActionsRESTfulControllerSpecification >> actionMappingKey [
	
	^ #action
]

{ #category : #'encoders and decoders' }
ActionsRESTfulControllerSpecification >> actionsJsonEncoderVersion1dot0dot0 [

	^ [ :actions :context | 
	String
		streamContents: [ :stream | 
			(NeoJSONWriter on: stream)
				for: Action
					do: [ :mapping | 
					mapping mapInstVar: #name.
					(mapping mapInstVar: #evaluationPolicy to: #http_request) valueSchema: #Policy.
					mapping mapAsHypermediaControls: [ :action | context hypermediaControlsFor: action ]  ];
				for: #Policy
					customDo: [ :mapping | mapping encoder: [ :policy | policy instVarNamed: #requestToSend ] ];
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
					customDo: [ :mapping | 
					mapping
						encoder: [ :dateTime | ISO8601DateTimeFormatter usingExtendedFormat format: dateTime ] ];
				nextPut: actions ] ]
]

{ #category : #accessing }
ActionsRESTfulControllerSpecification >> actionsMappingKey [
	
	^#actions
]

{ #category : #'specification - encoders and decoders' }
ActionsRESTfulControllerSpecification >> addActionJsonDecoderVersion1dot0dot0MappingIn: aBuilder [

	aBuilder
		addDefaultRuleToDecode: self applicationJsonVersion1dot0dot0MediaType
		to: self actionMappingKey 
		using: self actionJsonDecoderVersion1dot0dot0
]

{ #category : #'specification - encoders and decoders' }
ActionsRESTfulControllerSpecification >> addActionJsonEncoderVersion1dot0dot0MappingIn: aBuilder [

	aBuilder
		addDefaultRuleToEncode: self actionMappingKey
		to: self applicationJsonVersion1dot0dot0MediaType 
		using: self actionJsonEncoderVersion1dot0dot0.

	aBuilder
		addDefaultRuleToEncode: self actionsMappingKey
		to: self applicationJsonVersion1dot0dot0MediaType 
		using: self actionsJsonEncoderVersion1dot0dot0
]

{ #category : #'media types' }
ActionsRESTfulControllerSpecification >> applicationJsonVersion1dot0dot0MediaType [

	^ 'application/json;version=1.0.0' asMediaType
]

{ #category : #'specification - routes' }
ActionsRESTfulControllerSpecification >> createActionRoute [

	^ (RouteSpecification
		handling: #POST
		at: self endpoint
		sending: #createActionBasedOn:within:) asCorsAware
]

{ #category : #'specification - routes' }
ActionsRESTfulControllerSpecification >> deleteActionRoute [

	^ (RouteSpecification
		handling: #DELETE
		at: self idTemplate
		sending: #deleteActionBasedOn:within:) asCorsAware
]

{ #category : #accessing }
ActionsRESTfulControllerSpecification >> endpoint [

	^ '/actions'
]

{ #category : #'specification - routes' }
ActionsRESTfulControllerSpecification >> getActionRoute [

	^ RouteSpecification handling: #GET at: self idTemplate sending: #getActionBasedOn:within:
]

{ #category : #'specification - routes' }
ActionsRESTfulControllerSpecification >> getActionsRoute [

	^ RouteSpecification handling: #GET at: self endpoint sending: #getActionsBasedOn:within:
]

{ #category : #accessing }
ActionsRESTfulControllerSpecification >> idTemplate [

	^ '<1s>/%<<2s>:IsUUID>' expandMacrosWith: self endpoint with: self identifierKey
]

{ #category : #accessing }
ActionsRESTfulControllerSpecification >> identifierKey [

	^ #identifier
]
