Class {
	#name : #ActionManagementSystem,
	#superclass : #SubsystemImplementation,
	#instVars : [
		'actions',
		'evaluationSummaries'
	],
	#category : #'Cosmos-Actions'
}

{ #category : #querying }
ActionManagementSystem >> actionEvaluationSummaries [
	
	^ evaluationSummaries values
]

{ #category : #querying }
ActionManagementSystem >> actionIdentifiedBy: anIdentifier [

	^ self identifierSystem
		objectIdentifiedBy: anIdentifier
		ifNone: [ ObjectNotFound signal: 'Action with that identifier not found' ]
]

{ #category : #querying }
ActionManagementSystem >> actionNamed: aName [

	^ actions
		detect: [ :action | action name = aName ]
		ifNone: [ ObjectNotFound
				signal: ('Action named <1p> not found' expandMacrosWith: aName) ]
]

{ #category : #querying }
ActionManagementSystem >> actions [

	^ actions copy
]

{ #category : #'private - preconditions' }
ActionManagementSystem >> assertIsNotAlreadyRegistered: anAction [

	AssertionChecker
		refuse: [ actions includes: anAction ]
		because: 'An action with that name already exists in system'
		raising: ConflictingObjectFound
]

{ #category : #installing }
ActionManagementSystem >> dependencies [

	^ #(#TimestampingSystemInterface #IdentifierSystemInterface #EventNotificationSystemInterface)
]

{ #category : #managing }
ActionManagementSystem >> deregister: anAction [

	^ actions remove: anAction
]

{ #category : #systems }
ActionManagementSystem >> eventNotificationSystem [

	^ self >> #EventNotificationSystemInterface
]

{ #category : #'events handling' }
ActionManagementSystem >> handleActionEvaluatedOn: anEvent [

	evaluationSummaries
		at: anEvent action
		ifPresent: [ :summary | summary registerEvaluationOn: anEvent evaluationDateTime ]
		ifAbsentPut:
			(ActionEvaluationSummary
				of: anEvent action
				lastEvaluatedOn: anEvent evaluationDateTime
				totaling: 1)
]

{ #category : #'private - systems' }
ActionManagementSystem >> identifierSystem [

	^ self >> #IdentifierSystemInterface
]

{ #category : #installing }
ActionManagementSystem >> implementedInterfaces [ 

	^#(#ActionManagementSystemInterface)
]

{ #category : #initialization }
ActionManagementSystem >> initialize [

	super initialize.
	actions := OrderedCollection new.
	evaluationSummaries := Dictionary new.
]

{ #category : #accessing }
ActionManagementSystem >> name [

	^ 'Action Management'
]

{ #category : #managing }
ActionManagementSystem >> register: anAction [

	self assertIsNotAlreadyRegistered: anAction.
	
	actions add: anAction.
	self registerIdentifierFor: anAction.
	self registerTimestampFor: anAction.
	
	^ anAction
]

{ #category : #'private - managing' }
ActionManagementSystem >> registerIdentifierFor: anAction [

	self identifierSystem registerIdentifierFor: anAction
]

{ #category : #'private - managing' }
ActionManagementSystem >> registerTimestampFor: anAction [

	self timestampingSystem registerModificationFor: anAction
]

{ #category : #controlling }
ActionManagementSystem >> startUp [

	super startUp.

	self subscribeToActionEvaluatedEvents
]

{ #category : #'private - events handling' }
ActionManagementSystem >> subscribeToActionEvaluatedEvents [

	self eventNotificationSystem
		subscribe: self
		to: ActionEvaluatedEvent
		toBeNotifiedSending: #handleActionEvaluatedOn:
]

{ #category : #'private - systems' }
ActionManagementSystem >> timestampingSystem [

	^ self >> #TimestampingSystemInterface
]
