Class {
	#name : #ActionsWebService,
	#superclass : #RESTfulWebService,
	#instVars : [
		'cosmos'
	],
	#category : #'Cosmos-API-Actions'
}

{ #category : #'instance creation' }
ActionsWebService class >> workingWith: aCosmosSystem [
	
	^ self new initializeWorkingWith: aCosmosSystem
]

{ #category : #'private - systems' }
ActionsWebService >> actionManagementSystem [

	^ cosmos systemImplementing: #ActionManagementSystemInterface
]

{ #category : #API }
ActionsWebService >> createActionBasedOn: anHttpRequest within: aContext [

	^ [ [ | action |

	action := self
		decode: anHttpRequest contents
		at: #actions
		from: anHttpRequest contentType
		within: aContext.

	self actionManagementSystem register: action.

	ZnResponse created: (ZnUrl fromString: 'localhost') ]
		on: ConflictingObjectFound
		do: [ :signal | HTTPClientError signalConflict: signal messageText ] ]
		on: KeyNotFound , DecodingFailed
		do: [ :signal | 
			HTTPClientError
				signalBadRequest: ('Expected key <1s> was not found' expandMacrosWith: signal key) ]
]

{ #category : #API }
ActionsWebService >> deleteActionBasedOn: anHttpRequest within: aContext [

	| name |

	name := (anHttpRequest at: #name) replaceAll: $_ with: Character space.

	self actionManagementSystem
		actionNamed: name
		ifFound: [ :action | self actionManagementSystem deregister: action ]
		ifNone: [ ObjectNotFound signal ].

	^ ZnResponse noContent
]

{ #category : #API }
ActionsWebService >> getActionsBasedOn: anHttpRequest within: aContext [

	^ self
		get: [ self actionManagementSystem actions ]
		encodedUsing: #actions
		basedOn: anHttpRequest
		within: aContext
]

{ #category : #initialization }
ActionsWebService >> initializeWorkingWith: aCosmosSystem [

	cosmos := aCosmosSystem
]

{ #category : #specification }
ActionsWebService >> specification [
	
	^ ActionsWebServiceSpecification new
]
