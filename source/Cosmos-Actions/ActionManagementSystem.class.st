Class {
	#name : #ActionManagementSystem,
	#superclass : #System,
	#instVars : [
		'actions'
	],
	#category : #'Cosmos-Actions-SystemModel'
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

{ #category : #'initialize-release' }
ActionManagementSystem >> initialize [

	super initialize.

	timeSystem := self unresolvedSystemDependencyTo: #TimeSystemInterface.
	actions := OrderedCollection new
]

{ #category : #managing }
ActionManagementSystem >> register: anAction [

	self
		actionNamed: anAction name
		ifFound:
			[ :action | ConflictingObjectFound signal: 'An action with that name already exists in system' ]
		ifNone: [ actions add: anAction ]
]

{ #category : #'dependency resolution' }
ActionManagementSystem >> resolveDependecies [

	timeSystem := self resolveSystemDependencyTo: #TimeSystemInterface
]
