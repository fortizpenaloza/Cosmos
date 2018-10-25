Class {
	#name : #ActionManagementSystem,
	#superclass : #System,
	#instVars : [
		'actions',
		'timeSystem',
		'metadataSystem',
		'identifierSystem'
	],
	#category : #'Cosmos-Actions'
}

{ #category : #'system specification' }
ActionManagementSystem class >> implementedInterface [

	^ SystemInterface >> #ActionManagementSystemInterface
]

{ #category : #querying }
ActionManagementSystem >> actionNamed: aName ifFound: aFoundBlock ifNone: aNoneBlock [ 

	^ actions
		detect: [ :action | action name = aName ]
		ifFound: aFoundBlock
		ifNone: aNoneBlock 
]

{ #category : #querying }
ActionManagementSystem >> actions [

	^ actions copy
]

{ #category : #managing }
ActionManagementSystem >> deregister: action [

	^ actions remove: action
]

{ #category : #initialization }
ActionManagementSystem >> initialize [

	super initialize.

	timeSystem := self unresolvedSystemDependencyTo: #TimeSystemInterface.
	metadataSystem := self unresolvedSystemDependencyTo: #MetadataSystemInterface.
	identifierSystem := self unresolvedSystemDependencyTo: #IdentifierSystemInterface.

	actions := OrderedCollection new
]

{ #category : #managing }
ActionManagementSystem >> register: anAction [

	self
		actionNamed: anAction name
		ifFound: [ :action | 
			ConflictingObjectFound
				signal: 'An action with that name already exists in system' ]
		ifNone: [ self registerWithMetadata: anAction ].

	^ anAction
]

{ #category : #'private - managing' }
ActionManagementSystem >> registerIdentifierFor: anAction [

	identifierSystem registerIdentifierFor: anAction
]

{ #category : #'private - managing' }
ActionManagementSystem >> registerRegistrationTimestampFor: anAction [

	metadataSystem
		register:
			(Metadata
				attaching: timeSystem dateTime
				as: #registration_timestamp
				of: anAction)
]

{ #category : #'private - managing' }
ActionManagementSystem >> registerWithMetadata: anAction [

	actions add: anAction.

	self registerIdentifierFor: anAction .
	self registerRegistrationTimestampFor: anAction 
]

{ #category : #'dependency resolution' }
ActionManagementSystem >> resolveDependecies [

	timeSystem := self resolveSystemDependencyTo: #TimeSystemInterface.
	metadataSystem := self resolveSystemDependencyTo: #MetadataSystemInterface.
	identifierSystem := self resolveSystemDependencyTo: #IdentifierSystemInterface
]
