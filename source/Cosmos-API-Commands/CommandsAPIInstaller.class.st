Class {
	#name : #CommandsAPIInstaller,
	#superclass : #Object,
	#instVars : [
		'mappingRegistry',
		'interface',
		'server'
	],
	#category : #'Cosmos-API-Commands'
}

{ #category : #'instance creation' }
CommandsAPIInstaller class >> toInstallOn: aServer workingWith: aCosmosSystem [

	^ self new initializeToInstallOn: aServer workingWith: aCosmosSystem
]

{ #category : #'installing - encoders and decoders' }
CommandsAPIInstaller >> addCommandJsonDecoderVersion1dot0dot0Mapping [

	mappingRegistry
		add: self commandJsonDecoderVersion1dot0dot0
		asDecoderFor: self applicationJsonVersion1dot0dot0
		at: #commands
]

{ #category : #'installing - encoders and decoders' }
CommandsAPIInstaller >> addCommandJsonEncoderVersion1dot0dot0Mapping [

	mappingRegistry
		add: self commandJsonEncoderVersion1dot0dot0
		asEncoderFor: self applicationJsonVersion1dot0dot0
		at: #commands
]

{ #category : #'installing - encoders and decoders' }
CommandsAPIInstaller >> addCommandPlainTextEncoderMapping [

	mappingRegistry
		add: self commandPlainTextEncoder
		asEncoderFor: self textPlain
		at: #commands
]

{ #category : #'installing - routes' }
CommandsAPIInstaller >> addCreateCommandsRoute [

	server
		POST: '/commands' -> [ :request | interface createCommandBasedOn: request ].
	self addCommandJsonDecoderVersion1dot0dot0Mapping
]

{ #category : #'installing - routes' }
CommandsAPIInstaller >> addDeleteCommandsRoute [

	server DELETE: '/commands/<identifier:IsUUID>' -> [ :request | interface deleteCommandBasedOn: request ]
]

{ #category : #'installing - routes' }
CommandsAPIInstaller >> addGetCommandsRoute [

	server
		GET: '/commands' -> [ :request | interface getCommandsBasedOn: request ].
	self addCommandJsonEncoderVersion1dot0dot0Mapping
]

{ #category : #'installing - routes' }
CommandsAPIInstaller >> addNextCommandRoute [

	server
		POST:
			'/commands/next'
				-> [ :request | interface nextCommandBasedOn: request ].
	self addCommandPlainTextEncoderMapping
]

{ #category : #'MIME types' }
CommandsAPIInstaller >> applicationJsonVersion1dot0dot0 [

	^ ZnMimeType fromString: 'application/json;version=1.0.0'
]

{ #category : #'encoders and decoders' }
CommandsAPIInstaller >> commandJsonDecoderVersion1dot0dot0 [

	^ [ :aJSON | (NeoJSONReader
		on: aJSON readStream)
		for: CommandWithPriority
			customDo: [ :mapping | 
			mapping
				decoder: [ :rawCommand | 
					CommandWithPriority
						holding: (rawCommand at: #command)
						and: (rawCommand at: #priority) ] ];
		nextAs: CommandWithPriority ].
]

{ #category : #'encoders and decoders' }
CommandsAPIInstaller >> commandJsonEncoderVersion1dot0dot0 [

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
CommandsAPIInstaller >> commandPlainTextEncoder [

	^ [ :commandWithPriority | commandWithPriority command ]
]

{ #category : #initialization }
CommandsAPIInstaller >> initializeToInstallOn: aServer workingWith: aCosmosSystem [

	mappingRegistry := MappingRegistry new.
	interface := CommandsAPI
		workingWithin: (CommandsAPIContext workingWith: aCosmosSystem queryingMappingsTo: mappingRegistry).
	server := aServer
]

{ #category : #installing }
CommandsAPIInstaller >> install [

	self
		addCreateCommandsRoute;
		addGetCommandsRoute;
		addDeleteCommandsRoute;
		addNextCommandRoute.
				
	^ interface
]

{ #category : #'MIME types' }
CommandsAPIInstaller >> textPlain [

	^ ZnMimeType fromString: 'text/plain;charset=utf-8'
]
