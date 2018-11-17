Class {
	#name : #CommandsRESTfulControllerSpecification,
	#superclass : #ResourceRESTfulControllerSpecification,
	#category : #'Cosmos-API-Commands'
}

{ #category : #'specification - encoders and decoders' }
CommandsRESTfulControllerSpecification >> addCommandJsonDecoderVersion1dot0dot0MappingIn: aBuilder [

	aBuilder
		addDefaultRuleToDecode: self applicationJsonVersion1dot0dot0MediaType
		to: #commands
		using: self commandJsonDecoderVersion1dot0dot0
]

{ #category : #'specification - encoders and decoders' }
CommandsRESTfulControllerSpecification >> addCommandJsonEncoderVersion1dot0dot0MappingIn: aBuilder [

	aBuilder
		addDefaultRuleToEncode: #commands
		to: self applicationJsonVersion1dot0dot0MediaType
		using: self commandJsonEncoderVersion1dot0dot0
]

{ #category : #'specification - encoders and decoders' }
CommandsRESTfulControllerSpecification >> addCommandPlainTextEncoderMappingIn: aBuilder [

	aBuilder
		addRuleToEncode: #commands
		to: self textPlainMediaType 
		using: self commandPlainTextEncoder
]

{ #category : #'media types' }
CommandsRESTfulControllerSpecification >> applicationJsonVersion1dot0dot0MediaType [

	^ ZnMimeType fromString: 'application/json;version=1.0.0'
]

{ #category : #'encoders and decoders' }
CommandsRESTfulControllerSpecification >> commandJsonDecoderVersion1dot0dot0 [

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
CommandsRESTfulControllerSpecification >> commandJsonEncoderVersion1dot0dot0 [

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
CommandsRESTfulControllerSpecification >> commandPlainTextEncoder [

	^ [ :commandWithPriority | commandWithPriority command ]
]

{ #category : #'specification - routes' }
CommandsRESTfulControllerSpecification >> createCommandsRoute [

	^ RouteSpecification
		handling: #POST
		at: '/commands'
		sending: #createCommandBasedOn:within:
]

{ #category : #'specification - routes' }
CommandsRESTfulControllerSpecification >> deleteCommandsRoute [

	^ RouteSpecification
		handling: #DELETE
		at: '/commands/<identifier:IsUUID>'
		sending: #deleteCommandBasedOn:within:
]

{ #category : #'specification - routes' }
CommandsRESTfulControllerSpecification >> dequeueCommandRoute [

	^ RouteSpecification
		handling: #POST
		at: '/commands/dequeue'
		sending: #dequeueCommandBasedOn:within:

]

{ #category : #'specification - routes' }
CommandsRESTfulControllerSpecification >> getCommandsRoute [

	^ RouteSpecification 
		handling: #GET 
		at: '/commands'
	 	sending: #getCommandsBasedOn:within:
]

{ #category : #'media types' }
CommandsRESTfulControllerSpecification >> textPlainMediaType [

	^ ZnMimeType fromString: 'text/plain;charset=utf-8'
]
