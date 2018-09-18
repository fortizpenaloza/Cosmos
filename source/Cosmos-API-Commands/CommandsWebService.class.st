Class {
	#name : #CommandsWebService,
	#superclass : #Object,
	#instVars : [
		'cosmos',
		'mappingRuleSet'
	],
	#category : #'Cosmos-API-Commands'
}

{ #category : #'instance creation' }
CommandsWebService class >> workingWith: aCosmosSystem [
	
	^ self new initializeWorkingWith: aCosmosSystem
]

{ #category : #'private - systems' }
CommandsWebService >> commandManagementSystem [

	^ cosmos systemImplementing: #CommandManagementSystemInterface
]

{ #category : #API }
CommandsWebService >> createCommandBasedOn: anHttpRequest [

	| mediaType commandWithPriority commandWithPriorityLocation |

	mediaType := ZnMimeType fromString: anHttpRequest accept.

	commandWithPriority := cosmos
		decode: anHttpRequest contents
		encodedAs: mediaType
		to: #commands
		within: aContext.

	self commandManagementSystem register: commandWithPriority.

	commandWithPriorityLocation := self locationOf: commandWithPriority.

	^ ZnResponse created: commandWithPriorityLocation
]

{ #category : #API }
CommandsWebService >> deleteCommandBasedOn: anHttpRequest [

	^ [ | identifier |

	identifier := anHttpRequest at: #identifier.

	self commandManagementSystem
		withCommandIdentifiedBy: identifier
		do: [ :commandWithPriority | 
			self commandManagementSystem deregister: commandWithPriority.
			ZnResponse noContent ] ]
		on: ObjectNotFound
		do: [ :signal | HTTPClientError signalNotFound: signal messageText ]
]

{ #category : #API }
CommandsWebService >> getCommandsBasedOn: anHttpRequest [

	| mimeType encodedCommands |

	mimeType := self mediaTypeOf: anHttpRequest.

	encodedCommands := cosmos
		encode: self commandManagementSystem commands
		of: #commands
		to: mimeType
		within: aContext.

	^ ZnResponse ok: (ZnEntity json: encodedCommands)
]

{ #category : #'private - systems' }
CommandsWebService >> identifierSystem [

	^ cosmos systemImplementing: #IdentifierSystemInterface
]

{ #category : #initialization }
CommandsWebService >> initializeWorkingWith: aCosmosSystem [

	cosmos := aCosmosSystem.
	mappingRuleSet := (ReflectiveMappingRuleSetBuilder
		for: self specification) build
]

{ #category : #'private - API' }
CommandsWebService >> locationOf: commandWithPriority [

	^ ZnUrl
		fromString:
			('localhost/<1s>'
				expandMacrosWith: (self identifierSystem identifierOf: commandWithPriority) asString36)
]

{ #category : #'private - API' }
CommandsWebService >> mediaTypeOf: aHttpRequest [

	^ ZnMimeType fromString: aHttpRequest accept
]

{ #category : #API }
CommandsWebService >> nextCommandBasedOn: anHttpRequest [

	| mimeType encodedCommand |

	mimeType := self mediaTypeOf: anHttpRequest.

	encodedCommand := cosmos
		encode: self commandManagementSystem nextCommand
		of: #commands
		to: mimeType
		within: aContext.

	^ ZnResponse ok: (ZnEntity with: encodedCommand type: mimeType)
]
