Class {
	#name : #CommandsWebServiceSpecification,
	#superclass : #Object,
	#category : #'Cosmos-API-Commands'
}

{ #category : #'installing - encoders and decoders' }
CommandsWebServiceSpecification >> addCommandJsonDecoderVersion1dot0dot0Mapping [

	mappingRuleSetBuilder
		addDefaultRuleToDecode: self applicationJsonVersion1dot0dot0
		to: #commands
		using: self commandJsonDecoderVersion1dot0dot0
]

{ #category : #'installing - encoders and decoders' }
CommandsWebServiceSpecification >> addCommandJsonEncoderVersion1dot0dot0Mapping [

	mappingRuleSetBuilder
		addDefaultRuleToEncode: #commands
		to: self applicationJsonVersion1dot0dot0
		using: self commandJsonEncoderVersion1dot0dot0
]

{ #category : #'installing - encoders and decoders' }
CommandsWebServiceSpecification >> addCommandPlainTextEncoderMapping [

	mappingRuleSetBuilder
		addRuleToEncode: #commands
		to: self textPlain
		using: self commandPlainTextEncoder
]

{ #category : #'installing - routes' }
CommandsWebServiceSpecification >> addCreateCommandsRoute [

	server
		POST: '/commands' -> [ :request | interface createCommandBasedOn: request ]
]

{ #category : #'installing - routes' }
CommandsWebServiceSpecification >> addDeleteCommandsRoute [

	server
		DELETE:
			'/commands/<identifier:IsUUID>'
				-> [ :request | interface deleteCommandBasedOn: request ]
]

{ #category : #'installing - routes' }
CommandsWebServiceSpecification >> addGetCommandsRoute [

	server
		GET: '/commands' -> [ :request | interface getCommandsBasedOn: request ]
]

{ #category : #'installing - routes' }
CommandsWebServiceSpecification >> addNextCommandRoute [

	server
		POST:
			'/commands/getNext'
				-> [ :request | interface nextCommandBasedOn: request ]
]

{ #category : #'MIME types' }
CommandsWebServiceSpecification >> applicationJsonVersion1dot0dot0 [

	^ ZnMimeType fromString: 'application/json;version=1.0.0'
]

{ #category : #'encoders and decoders' }
CommandsWebServiceSpecification >> commandJsonDecoderVersion1dot0dot0 [

	^ [ :aJSON | 
	(NeoJSONReader on: aJSON readStream)
		for: CommandWithPriority
			customDo: [ :mapping | 
			mapping
				decoder:
					[ :rawCommand | CommandWithPriority holding: (rawCommand at: #command) and: (rawCommand at: #priority) ] ];
		nextAs: CommandWithPriority ]
]

{ #category : #'encoders and decoders' }
CommandsWebServiceSpecification >> commandJsonEncoderVersion1dot0dot0 [

	^ [ :commandWithPriority | 
	String
		streamContents: [ :stream | 
			(NeoJSONWriter on: stream)
				for: CommandWithPriority
					do: [ :mapping | 
					mapping
						mapAccessor: #command;
						mapAccessor: #priority ];
				nextPut: commandWithPriority ] ]
]

{ #category : #'encoders and decoders' }
CommandsWebServiceSpecification >> commandPlainTextEncoder [

	^ [ :commandWithPriority | commandWithPriority command ]
]

{ #category : #installing }
CommandsWebServiceSpecification >> install [

	self
		addCreateCommandsRoute;
		addGetCommandsRoute;
		addDeleteCommandsRoute;
		addNextCommandRoute.
				
	^ interface
]

{ #category : #'MIME types' }
CommandsWebServiceSpecification >> textPlain [

	^ ZnMimeType fromString: 'text/plain;charset=utf-8'
]
