Class {
	#name : #CommandsRESTfulControllerSpecification,
	#superclass : #ResourceRESTfulControllerSpecification,
	#category : #'Cosmos-API-Commands'
}

{ #category : #'specification - encoders and decoders' }
CommandsRESTfulControllerSpecification >> addCommandJsonDecoderVersion1dot0dot0MappingIn: aBuilder [

	aBuilder
		addDefaultRuleToDecode: self applicationJsonVersion1dot0dot0MediaType
		to: self commandMappingKey 
		using: self commandJsonDecoderVersion1dot0dot0
]

{ #category : #'specification - encoders and decoders' }
CommandsRESTfulControllerSpecification >> addCommandJsonEncoderVersion1dot0dot0MappingIn: aBuilder [

	aBuilder
		addDefaultRuleToEncode: self commandMappingKey 
		to: self applicationJsonVersion1dot0dot0MediaType
		using: self commandJsonEncoderVersion1dot0dot0.
		
	aBuilder
		addDefaultRuleToEncode: self commandsMappingKey 
		to: self applicationJsonVersion1dot0dot0MediaType
		using: self commandsJsonEncoderVersion1dot0dot0
]

{ #category : #'specification - encoders and decoders' }
CommandsRESTfulControllerSpecification >> addCommandPlainTextEncoderMappingIn: aBuilder [

	aBuilder
		addRuleToEncode: self commandMappingKey
		to: self textPlainMediaType
		using: self commandPlainTextEncoder
]

{ #category : #'media types' }
CommandsRESTfulControllerSpecification >> applicationJsonVersion1dot0dot0MediaType [

	^ 'application/json;version=1.0.0' asMediaType 
]

{ #category : #'encoders and decoders' }
CommandsRESTfulControllerSpecification >> commandJsonDecoderVersion1dot0dot0 [

	^ [ :json | 
	(NeoJSONReader on: json readStream)
		for: CommandWithPriority
			customDo: [ :mapping | 
			mapping
				decoder:
					[ :rawCommand | 
						CommandWithPriority 
							holding: (rawCommand at: #command) 
							and: (rawCommand at: #priority) ] ];
		nextAs: CommandWithPriority ]
]

{ #category : #'encoders and decoders' }
CommandsRESTfulControllerSpecification >> commandJsonEncoderVersion1dot0dot0 [

	^ [ :commandWithPriority :context | 
	String
		streamContents: [ :stream | 
			(NeoJSONWriter on: stream)
				for: CommandWithPriority
					do: [ :mapping | 
					mapping
						mapAccessor: #command;
						mapAccessor: #priority;
						mapHypermediaControlsIn: context ];
				nextPut: commandWithPriority ] ]
]

{ #category : #accessing }
CommandsRESTfulControllerSpecification >> commandMappingKey [

	^ #command
]

{ #category : #'encoders and decoders' }
CommandsRESTfulControllerSpecification >> commandPlainTextEncoder [

	^ [ :commandWithPriority | commandWithPriority command ]
]

{ #category : #'encoders and decoders' }
CommandsRESTfulControllerSpecification >> commandsJsonEncoderVersion1dot0dot0 [

	^ [ :commandsWithPriority :context | 
	String
		streamContents: [ :stream | 
			(NeoJSONWriter on: stream)
				for: CommandWithPriority
					do: [ :mapping | 
					mapping
						mapAccessor: #command;
						mapAccessor: #priority;
						mapAsHypermediaControls: [ :commandWithPriority | context hypermediaControlsFor: commandWithPriority ] ];
				nextPut: commandsWithPriority ] ]
]

{ #category : #accessing }
CommandsRESTfulControllerSpecification >> commandsMappingKey [

	^ #commands
]

{ #category : #'specification - routes' }
CommandsRESTfulControllerSpecification >> createCommandsRoute [

	^ (RouteSpecification
		handling: #POST
		at: self endpoint
		sending: #createCommandBasedOn:within:) asCorsAware
]

{ #category : #'specification - routes' }
CommandsRESTfulControllerSpecification >> deleteCommandsRoute [

	^ (RouteSpecification
		handling: #DELETE
		at: self idTemplate
		sending: #deleteCommandBasedOn:within:) asCorsAware 
]

{ #category : #'specification - routes' }
CommandsRESTfulControllerSpecification >> dequeueCommandRoute [

	^ RouteSpecification
		handling: #POST
		at: '/commands/dequeue'
		sending: #dequeueCommandBasedOn:within:

]

{ #category : #accessing }
CommandsRESTfulControllerSpecification >> endpoint [ 

	^ '/commands'
]

{ #category : #'specification - routes' }
CommandsRESTfulControllerSpecification >> getCommandRoute [

	^ RouteSpecification
		handling: #GET
		at: self idTemplate
		sending: #getCommandsBasedOn:within:
]

{ #category : #'specification - routes' }
CommandsRESTfulControllerSpecification >> getCommandsRoute [

	^ RouteSpecification 
		handling: #GET 
		at: self endpoint
	 	sending: #getCommandsBasedOn:within:
]

{ #category : #accessing }
CommandsRESTfulControllerSpecification >> idTemplate [

	^ '<1s>/%<<2s>:IsUUID>' expandMacrosWith: self endpoint with: self identifierKey
]

{ #category : #accessing }
CommandsRESTfulControllerSpecification >> identifierKey [

	^ #identifier
]

{ #category : #'media types' }
CommandsRESTfulControllerSpecification >> textPlainMediaType [

	^ 'text/plain;charset=utf-8' asMediaType
]
