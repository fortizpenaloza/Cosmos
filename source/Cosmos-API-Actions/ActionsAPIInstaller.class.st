Class {
	#name : #ActionsAPIInstaller,
	#superclass : #Object,
	#instVars : [
		'server',
		'interface',
		'mappingRuleSetBuilder'
	],
	#category : #'Cosmos-API-Actions'
}

{ #category : #'instance creation' }
ActionsAPIInstaller class >> toInstallOn: aServer workingWith: aCosmosSystem [

	^ self new initializeToInstallOn: aServer workingWith: aCosmosSystem
]

{ #category : #'private-encoding' }
ActionsAPIInstaller >> actionJsonEncoderVersion1dot0dot0 [

	^ [ :action | 
	String
		streamContents: [ :stream | 
			(NeoJSONWriter on: stream)
				for: Action
					do: [ :mapping | 
					mapping
						mapAccessor: #name;
						mapAccessor: #creationDateTime to: #created_on;
						mapInstVar: #evaluationPolicy to: #http_request ];
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
				prettyPrint: true;
				nextPut: action ] ]
]

{ #category : #'private-encoding' }
ActionsAPIInstaller >> actionJsonVersion1dot0dot0MimeType [

	^ ZnMimeType fromString: 'application/vnd.cosmos.action+json; version=1.0.0'
]

{ #category : #'private-installing' }
ActionsAPIInstaller >> addCrossOriginResourceSharingRouteXX [

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
ActionsAPIInstaller >> addDeregisterActionRoute [

	server
		DELETE:
			'/actions/<name>'
				-> [ :request | interface deregisterNamed: (request at: #name) ];
		output: #text
]

{ #category : #'private-installing' }
ActionsAPIInstaller >> addGetActionsRoute [

	server GET: '/actions' -> [ :request | interface actionsFor: request ]
]

{ #category : #'private-installing' }
ActionsAPIInstaller >> addRegisterActionRoute [

	server POST: '/actions' -> [ :request | interface registerHandling: request contents ]
]

{ #category : #initialization }
ActionsAPIInstaller >> initializeToInstallOn: aServer workingWith: aCosmosSystem [

	mappingRuleSetBuilder := MappingRuleSetBuilder new.
		
	self registerActionJsonEncoderVersion1dot0dot0.
	
	interface := ActionsAPI workingWithin: (ActionsAPIContext workingWith: aCosmosSystem  queryingMappingsTo: mappingRuleSetBuilder build).
	server := aServer
]

{ #category : #installing }
ActionsAPIInstaller >> install [

	self
		addGetActionsRoute;
		addRegisterActionRoute;
		addDeregisterActionRoute;
		addCrossOriginResourceSharingRouteXX.

	^ interface
]

{ #category : #'private-encoding' }
ActionsAPIInstaller >> registerActionJsonEncoderVersion1dot0dot0 [

	mappingRuleSetBuilder
		addDefaultRuleToEncode: #actions
		to: self actionJsonVersion1dot0dot0MimeType
		using: self actionJsonEncoderVersion1dot0dot0
]
