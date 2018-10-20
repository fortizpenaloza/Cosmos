Class {
	#name : #CommandsRESTfulWebService,
	#superclass : #RESTfulWebService,
	#instVars : [
		'cosmos'
	],
	#category : #'Cosmos-API-Commands'
}

{ #category : #'instance creation' }
CommandsRESTfulWebService class >> workingWith: aCosmosSystem [
	
	^ self new initializeWorkingWith: aCosmosSystem
]

{ #category : #'private - systems' }
CommandsRESTfulWebService >> commandManagementSystem [

	^ cosmos systemImplementing: #CommandManagementSystemInterface
]

{ #category : #API }
CommandsRESTfulWebService >> createCommandBasedOn: anHttpRequest within: aContext [

	^ self
		withCreatedResourceDo: [ :commandWithPriority | self commandManagementSystem register: commandWithPriority ]
		decodedUsing: #commands
		basedOn: anHttpRequest
		within: aContext
]

{ #category : #API }
CommandsRESTfulWebService >> deleteCommandBasedOn: anHttpRequest within: aContext [

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
CommandsRESTfulWebService >> dequeueCommandBasedOn: anHttpRequest within: aContext [

	^ self
		get: [ self commandManagementSystem nextCommand ]
		encodedUsing: #commands
		basedOn: anHttpRequest
		within: aContext
]

{ #category : #API }
CommandsRESTfulWebService >> getCommandsBasedOn: anHttpRequest within: aContext [

	^ self
		get: [ self commandManagementSystem commands ]
		asCollectionEncodedUsing: #commands
		basedOn: anHttpRequest
		within: aContext
]

{ #category : #'private - systems' }
CommandsRESTfulWebService >> identifierSystem [

	^ cosmos systemImplementing: #IdentifierSystemInterface
]

{ #category : #initialization }
CommandsRESTfulWebService >> initializeWorkingWith: aCosmosSystem [

	cosmos := aCosmosSystem
]

{ #category : #'private - API' }
CommandsRESTfulWebService >> locationOf: aCommandWithPriority [

	| baseUrl |

	baseUrl := baseUrlOptional
		withContentDo: [ :theBaseUrl | theBaseUrl ]
		ifUnused: [ '' asZnUrl ].

	^ '<1p>/<2p>'
		expandMacrosWith: baseUrl / 'commands' asZnUrl
		with: (self identifierSystem identifierOf: aCommandWithPriority)
]

{ #category : #specification }
CommandsRESTfulWebService >> specification [

	^ CommandsRESTfulWebServiceSpecification new
]
