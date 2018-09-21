Class {
	#name : #ActionsWebServiceSpecification,
	#superclass : #Object,
	#instVars : [
		'server',
		'interface',
		'mappingRuleSetBuilder'
	],
	#category : #'Cosmos-API-Actions'
}

{ #category : #'instance creation' }
ActionsWebServiceSpecification class >> toInstallOn: aServer workingWith: aCosmosSystem [

	^ self new initializeToInstallOn: aServer workingWith: aCosmosSystem
]

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

{ #category : #'private-installing' }
ActionsWebServiceSpecification >> addCrossOriginResourceSharingRouteXX [

	server
		OPTIONS:
			'/actions'
				-> [ :request | 
					| response |

					response := ZnResponse noContent.

					response headers
						at: 'Access-Control-Allow-Headers'
							put: 'Access-Control-Allow-Origin, Content-Type, Accept';
						at: 'Access-Control-Allow-Methods' put: 'POST, GET, DELETE, PUT';
						at: 'Access-Control-Max-Age' put: '86400'.

					response ]
]

{ #category : #'private-installing' }
ActionsWebServiceSpecification >> addDeregisterActionRoute [

	server
		DELETE:
			'/actions/<name>'
				-> [ :request | interface deregisterNamed: (request at: #name) ];
		output: #text
]

{ #category : #'private-installing' }
ActionsWebServiceSpecification >> addGetActionsRoute [

	server GET: '/actions' -> [ :request | interface getActionsBasedOn: request within: HttpRequestContext new ]
]

{ #category : #'private-installing' }
ActionsWebServiceSpecification >> addRegisterActionRoute [

	server POST: '/actions' -> [ :request | interface registerHandling: request contents ]
]

{ #category : #'media types' }
ActionsWebServiceSpecification >> applicationJsonVersion1dot0dot0 [

	^ ZnMimeType fromString: 'application/json;version=1.0.0'
]

{ #category : #initialization }
ActionsWebServiceSpecification >> initializeToInstallOn: aServer workingWith: aCosmosSystem [

	mappingRuleSetBuilder := MappingRuleSetBuilder new.

	self addActionJsonEncoderVersion1dot0dot0MappingIn: nil.

	interface := ActionsWebService
		workingWithin:
			(ActionsAPIContext
				workingWith: aCosmosSystem
				queryingMappingsTo: mappingRuleSetBuilder build).
	server := aServer
]

{ #category : #installing }
ActionsWebServiceSpecification >> install [

	self
		addGetActionsRoute;
		addRegisterActionRoute;
		addDeregisterActionRoute;
		addCrossOriginResourceSharingRouteXX.

	^ interface
]
