Class {
	#name : #CommandsAPI,
	#superclass : #Object,
	#instVars : [
		'context'
	],
	#category : #'Cosmos-API-Commands'
}

{ #category : #'instance creation' }
CommandsAPI class >> workingWithin: aContext [
	
	^ self new initializeWorkingWithin: aContext
]

{ #category : #'private - API' }
CommandsAPI >> acceptMimeTypeOf: aHttpRequest [

	^ ZnMimeType fromString: aHttpRequest accept
]

{ #category : #'private - systems' }
CommandsAPI >> commandManagementSystem [

	^ context systemImplementing: #CommandManagementSystemInterface
]

{ #category : #API }
CommandsAPI >> createCommandBasedOn: anHttpRequest [

	| contentType commandWithPriority commandWithPriorityLocation |

	contentType := ZnMimeType applicationJson.

	commandWithPriority := context
		decode: anHttpRequest contents
		encodedAs: contentType
		within: #commands.

	self commandManagementSystem register: commandWithPriority.

	commandWithPriorityLocation := self locationOf: commandWithPriority.

	^ ZnResponse created: commandWithPriorityLocation
]

{ #category : #API }
CommandsAPI >> deleteCommandBasedOn: anHttpRequest [

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
CommandsAPI >> getCommandsBasedOn: anHttpRequest [

	| mimeType encodedCommands |

	mimeType := self acceptMimeTypeOf: anHttpRequest.

	encodedCommands := context
		encode: self commandManagementSystem commands
		of: #commands
		to: mimeType.

	^ ZnResponse ok: (ZnEntity json: encodedCommands)
]

{ #category : #'private - systems' }
CommandsAPI >> identifierSystem [

	^ context systemImplementing: #IdentifierSystemInterface
]

{ #category : #initialization }
CommandsAPI >> initializeWorkingWithin: aContext [

	context := aContext
]

{ #category : #'private - API' }
CommandsAPI >> locationOf: commandWithPriority [

	^ ZnUrl
		fromString:
			('localhost/<1s>'
				expandMacrosWith: (self identifierSystem identifierOf: commandWithPriority) asString36)
]

{ #category : #API }
CommandsAPI >> nextCommandBasedOn: anHttpRequest [

	| mimeType encodedCommand |

	mimeType := self acceptMimeTypeOf: anHttpRequest.

	encodedCommand := context
		encode: self commandManagementSystem nextCommand
		of: #commands
		to: mimeType.

	^ ZnResponse ok: (ZnEntity with: encodedCommand type: mimeType)
]
