Class {
	#name : #CommandsWebService,
	#superclass : #RESTfulWebService,
	#instVars : [
		'cosmos'
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
CommandsWebService >> createCommandBasedOn: anHttpRequest within: aContext [

	| mediaType commandWithPriority |

	mediaType := self mediaTypeOf: anHttpRequest.

	commandWithPriority := self
		decode: anHttpRequest contents
		at: #commands
		from: mediaType
		within: aContext.

	self commandManagementSystem register: commandWithPriority.

	^ ZnResponse created: (self locationOf: commandWithPriority)
]

{ #category : #API }
CommandsWebService >> deleteCommandBasedOn: anHttpRequest within: aContext [

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
CommandsWebService >> getCommandsBasedOn: anHttpRequest within: aContext [

	^ self
		get: [ self commandManagementSystem commands ]
		encodedUsing: #commands
		basedOn: anHttpRequest
		within: aContext
]

{ #category : #'private - systems' }
CommandsWebService >> identifierSystem [

	^ cosmos systemImplementing: #IdentifierSystemInterface
]

{ #category : #initialization }
CommandsWebService >> initializeWorkingWith: aCosmosSystem [

	cosmos := aCosmosSystem
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

	^ self targetMediaTypeFrom: aHttpRequest
]

{ #category : #API }
CommandsWebService >> nextCommandBasedOn: anHttpRequest within: aContext [

	^ self
		get: [ self commandManagementSystem nextCommand ]
		encodedUsing: #commands
		basedOn: anHttpRequest
		within: aContext
]

{ #category : #specification }
CommandsWebService >> specification [

	^ CommandsWebServiceSpecification new
]
