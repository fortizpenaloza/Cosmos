Class {
	#name : #ActionManagementSystem,
	#superclass : #SubsystemImplementation,
	#instVars : [
		'actions'
	],
	#category : #'Cosmos-Actions'
}

{ #category : #querying }
ActionManagementSystem >> actionIdentifiedBy: anIdentifier [

	^ self identifierSystem
		objectIdentifiedBy: anIdentifier
		ifNone: [ ObjectNotFound signal: 'Action with that identifier not found' ]
]

{ #category : #querying }
ActionManagementSystem >> actionNamed: aName ifFound: aFoundBlock [

	^ actions
		detect: [ :action | action name = aName ]
		ifFound: aFoundBlock
		ifNone: [ ObjectNotFound signal: ('Action named <1s> not found' expandMacrosWith: aName) ]
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

	^ #(#TimeSystemInterface #MetadataSystemInterface #IdentifierSystemInterface)
]

{ #category : #managing }
ActionManagementSystem >> deregister: anAction [

	^ actions remove: anAction
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
	actions := OrderedCollection new
]

{ #category : #'private - systems' }
ActionManagementSystem >> metadataSystem [

	^ self >> #MetadataSystemInterface
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
	self registerRegistrationTimestampFor: anAction.
	
	^ anAction
]

{ #category : #'private - managing' }
ActionManagementSystem >> registerIdentifierFor: anAction [

	self identifierSystem registerIdentifierFor: anAction
]

{ #category : #'private - managing' }
ActionManagementSystem >> registerRegistrationTimestampFor: anAction [

	self metadataSystem
		register:
			(Metadata
				attaching: self timeSystem dateTime
				as: #registration_timestamp
				of: anAction)
]

{ #category : #'private - systems' }
ActionManagementSystem >> timeSystem [

	^ self >> #TimeSystemInterface
]
