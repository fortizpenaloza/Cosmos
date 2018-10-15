Class {
	#name : #CommandsWebServiceSpecification,
	#superclass : #RESTFulWebServiceSpecification,
	#category : #'Cosmos-API-Commands'
}

{ #category : #'specification - encoders and decoders' }
CommandsWebServiceSpecification >> addCommandJsonDecoderVersion1dot0dot0MappingIn: aBuilder [

	aBuilder
		addDefaultRuleToDecode: self applicationJsonVersion1dot0dot0
		to: #commands
		using: self commandJsonDecoderVersion1dot0dot0
]

{ #category : #'specification - encoders and decoders' }
CommandsWebServiceSpecification >> addCommandJsonEncoderVersion1dot0dot0MappingIn: aBuilder [

	aBuilder
		addDefaultRuleToEncode: #commands
		to: self applicationJsonVersion1dot0dot0
		using: self commandJsonEncoderVersion1dot0dot0
]

{ #category : #'specification - encoders and decoders' }
CommandsWebServiceSpecification >> addCommandPlainTextEncoderMappingIn: aBuilder [

	aBuilder
		addRuleToEncode: #commands
		to: self textPlain
		using: self commandPlainTextEncoder
]

{ #category : #'media types' }
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

{ #category : #'specification - routes' }
CommandsWebServiceSpecification >> createCommandsRoute [

	^ RouteSpecification
		handling: #POST
		at: '/commands'
		sending: #createCommandBasedOn:within:
]

{ #category : #'specification - routes' }
CommandsWebServiceSpecification >> deleteCommandsRoute [

	^ RouteSpecification
		handling: #DELETE
		at: '/commands/<identifier:IsUUID>'
		sending: #deleteCommandBasedOn:within:
]

{ #category : #'specification - routes' }
CommandsWebServiceSpecification >> getCommandsRoute [

	^ RouteSpecification 
		handling: #GET 
		at: '/commands'
	 	sending: #getCommandsBasedOn:within:
]

{ #category : #'specification - routes' }
CommandsWebServiceSpecification >> getNextCommandRoute [

	^ RouteSpecification
		handling: #POST
		at: '/commands/getNext'
		sending: #nextCommandBasedOn:within:

]

{ #category : #'media types' }
CommandsWebServiceSpecification >> textPlain [

	^ ZnMimeType fromString: 'text/plain;charset=utf-8'
]
