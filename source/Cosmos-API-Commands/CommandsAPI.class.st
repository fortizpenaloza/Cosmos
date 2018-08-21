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
CommandsAPI >> createCommandBasedOn: aHttpRequest [

	| contentType commandWithPriority commandWithPriorityLocation |

	contentType := ZnMimeType applicationJson.
	
	commandWithPriority  := context
		decode: aHttpRequest contents
		encodedAs: contentType.

	self commandManagementSystem register: commandWithPriority.

	commandWithPriorityLocation := self locationOf: commandWithPriority.

	^ ZnResponse created: commandWithPriorityLocation
]

{ #category : #API }
CommandsAPI >> getCommandsBasedOn: aHttpRequest [

	| mimeType encodedCommands |

	mimeType := self acceptMimeTypeOf: aHttpRequest.

	encodedCommands := context
		encode: self commandManagementSystem commands
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
CommandsAPI >> nextCommandBasedOn: aHttpRequest [

	| mimeType encodedCommand |

	mimeType := self acceptMimeTypeOf: aHttpRequest.

	encodedCommand := context
		encode: self commandManagementSystem nextCommand
		to: mimeType.

	^ ZnResponse ok: (ZnEntity with: encodedCommand type: mimeType)
]
