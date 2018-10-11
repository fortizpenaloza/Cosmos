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

	^ self
		withCreatedResourceDo: [ :action | self actionManagementSystem register: action ]
		decodedUsing: #actions
		basedOn: anHttpRequest
		within: aContext
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

{ #category : #'private - systems' }
ActionsWebService >> locationOf: resource [

	"Fran, you have to improve it"

	^ ZnUrl fromString: 'localhost'
]

{ #category : #specification }
ActionsWebService >> specification [
	
	^ ActionsWebServiceSpecification new
]
