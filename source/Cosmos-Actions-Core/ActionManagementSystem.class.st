Class {
	#name : #ActionManagementSystem,
	#superclass : #System,
	#instVars : [
		'timeSystem',
		'actions'
	],
	#category : 'Cosmos-Actions-Core-SystemModel'
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

{ #category : #'private-managing' }
ActionManagementSystem >> deregister: action [

	^ actions remove: action
]

{ #category : #managing }
ActionManagementSystem >> deregisterNamed: aName [

	self
		actionNamed: aName
		ifFound: [ :action | self deregister: action ]
		ifNone: [ ObjectNotFound signal: 'Action not found in system' ]
]

{ #category : #'initialize-release' }
ActionManagementSystem >> initialize [

	super initialize.

	timeSystem := self unresolvedSystemDependencyTo: #TimeSystemInterface.
	actions := OrderedCollection new
]

{ #category : #'private-managing' }
ActionManagementSystem >> register: anAction [

	actions
		detect: [ :action | action name = anAction name ]
		ifFound: [ :action | ConflictingObjectFound signal: 'An action with that name already exists in system' ]
		ifNone: [ actions add: anAction ]
]

{ #category : #managing }
ActionManagementSystem >> registerNamed: aName toEvaluate: aEvaluationPolicy [

	| action |

	action := Action
		named: aName
		createdOn: timeSystem dateTime
		toEvaluate: aEvaluationPolicy.

	self register: action.

	^ action
]

{ #category : #'dependency resolution' }
ActionManagementSystem >> resolveDependecies [

	timeSystem := self resolveSystemDependencyTo: #TimeSystemInterface
]
