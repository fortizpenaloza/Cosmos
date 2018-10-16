Class {
	#name : #CommandsRESTfulWebServiceSpecification,
	#superclass : #RESTFulWebServiceSpecification,
	#category : #'Cosmos-API-Commands'
}

{ #category : #'specification - encoders and decoders' }
CommandsRESTfulWebServiceSpecification >> addCommandJsonDecoderVersion1dot0dot0MappingIn: aBuilder [

	aBuilder
		addDefaultRuleToDecode: self applicationJsonVersion1dot0dot0
		to: #commands
		using: self commandJsonDecoderVersion1dot0dot0
]

{ #category : #'specification - encoders and decoders' }
CommandsRESTfulWebServiceSpecification >> addCommandJsonEncoderVersion1dot0dot0MappingIn: aBuilder [

	aBuilder
		addDefaultRuleToEncode: #commands
		to: self applicationJsonVersion1dot0dot0
		using: self commandJsonEncoderVersion1dot0dot0
]

{ #category : #'specification - encoders and decoders' }
CommandsRESTfulWebServiceSpecification >> addCommandPlainTextEncoderMappingIn: aBuilder [

	aBuilder
		addRuleToEncode: #commands
		to: self textPlain
		using: self commandPlainTextEncoder
]

{ #category : #'media types' }
CommandsRESTfulWebServiceSpecification >> applicationJsonVersion1dot0dot0 [

	^ ZnMimeType fromString: 'application/json;version=1.0.0'
]

{ #category : #'encoders and decoders' }
CommandsRESTfulWebServiceSpecification >> commandJsonDecoderVersion1dot0dot0 [

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
CommandsRESTfulWebServiceSpecification >> commandJsonEncoderVersion1dot0dot0 [

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
CommandsRESTfulWebServiceSpecification >> commandPlainTextEncoder [

	^ [ :commandWithPriority | commandWithPriority command ]
]

{ #category : #'specification - routes' }
CommandsRESTfulWebServiceSpecification >> createCommandsRoute [

	^ RouteSpecification
		handling: #POST
		at: '/commands'
		sending: #createCommandBasedOn:within:
]

{ #category : #'specification - routes' }
CommandsRESTfulWebServiceSpecification >> deleteCommandsRoute [

	^ RouteSpecification
		handling: #DELETE
		at: '/commands/<identifier:IsUUID>'
		sending: #deleteCommandBasedOn:within:
]

{ #category : #'specification - routes' }
CommandsRESTfulWebServiceSpecification >> getCommandsRoute [

	^ RouteSpecification 
		handling: #GET 
		at: '/commands'
	 	sending: #getCommandsBasedOn:within:
]

{ #category : #'specification - routes' }
CommandsRESTfulWebServiceSpecification >> getNextCommandRoute [

	^ RouteSpecification
		handling: #POST
		at: '/commands/getNext'
		sending: #nextCommandBasedOn:within:

]

{ #category : #'media types' }
CommandsRESTfulWebServiceSpecification >> textPlain [

	^ ZnMimeType fromString: 'text/plain;charset=utf-8'
]
