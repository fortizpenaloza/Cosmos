"
I'm TriggerSystem, a system that manages triggers related to feeds.

My main responsability is to manage triggers and evaluate them when a condition matches.


"
Class {
	#name : #TriggerManagementSystem,
	#superclass : #System,
	#instVars : [
		'eventNotificationSystem',
		'timeSystem',
		'metadataSystem',
		'identifierSystem',
		'triggers',
		'triggersToTriggerPeriodically',
		'triggersToTriggerAfterDataPointRegistration'
	],
	#category : #'Cosmos-Triggers-SystemModel'
}

{ #category : #'system specification' }
TriggerManagementSystem class >> implementedInterface [

	^ SystemInterface >> #TriggerManagementSystemInterface
]

{ #category : #'events handling' }
TriggerManagementSystem >> dataPointRegisteredOn: anEvent [

	(self triggersToTriggerAfterDataPointRegistrationOn: anEvent dataStream)
		do: [ :trigger | 
			trigger
				ifSatisfiedOn: self triggeringContext
				withActionDo: [ :action | self notifyEvaluationOf: action ] ]
]

{ #category : #'private - managing' }
TriggerManagementSystem >> deregister: aTrigger accordingTo: aTriggeringPolicy [ 

	aTriggeringPolicy deregister: aTrigger from: self.
	triggers remove: aTrigger
]

{ #category : #'private - managing' }
TriggerManagementSystem >> deregister: aTrigger fromTriggeredPeriodicallyEvery: aTimePeriod [ 

	(self triggersToTriggerPeriodicallyEvery: aTimePeriod) remove: aTrigger 
]

{ #category : #'private - managing' }
TriggerManagementSystem >> deregister: aTrigger toStopTriggeringAfterDataPointRegistrationOn: aDataStream [ 
	
	(self triggersToTriggerAfterDataPointRegistrationOn: aDataStream) remove: aTrigger 	
]

{ #category : #managing }
TriggerManagementSystem >> deregisterNamed: aName [

	self
		triggerNamed: aName
		ifFound: [ :trigger | self deregister: trigger accordingTo: trigger triggeringPolicy ]
		ifNone: [ ObjectNotFound signal: 'Trigger not found in the system' ]
]

{ #category : #'events handling' }
TriggerManagementSystem >> havePassed: aTickEvent [
	
	(self triggersToTriggerPeriodicallyEvery: aTickEvent timePeriod)
		do: [ :trigger | 
			trigger
				ifSatisfiedOn: self triggeringContext
				withActionDo: [ :action | self notifyEvaluationOf: action ] ]
]

{ #category : #initialization }
TriggerManagementSystem >> initialize [

	super initialize.
	
	eventNotificationSystem := self unresolvedSystemDependencyTo: #EventNotificationSystemInterface.
	timeSystem := self unresolvedSystemDependencyTo: #TimeSystemInterface.
	metadataSystem := self unresolvedSystemDependencyTo: #MetadataSystemInterface.
	identifierSystem := self unresolvedSystemDependencyTo: #IdentifierSystemInterface.

	triggers := OrderedCollection new.
	triggersToTriggerAfterDataPointRegistration := Dictionary new.
	triggersToTriggerPeriodically := Dictionary new
]

{ #category : #'events handling' }
TriggerManagementSystem >> notifyEvaluationOf: action [

	^ eventNotificationSystem notifySubscribersTo: (EvaluateActionEvent of: action)
]

{ #category : #managing }
TriggerManagementSystem >> register: anActionTrigger [

	self
		triggerNamed: anActionTrigger name
		ifFound:
			[ :trigger | ConflictingObjectFound signal: 'Trigger with that name already exists in system' ]
		ifNone: [ self register: anActionTrigger accordingTo: anActionTrigger triggeringPolicy ]
]

{ #category : #'private - managing' }
TriggerManagementSystem >> register: aTrigger accordingTo: aTriggeringPolicy [

	triggers add: aTrigger.
	aTriggeringPolicy register: aTrigger to: self.

	self registerIdentifierFor: aTrigger.
	self registerRegistrationTimestampFor: aTrigger
]

{ #category : #'private - managing' }
TriggerManagementSystem >> register: aTrigger toTriggerAfterDataPointRegistrationOn: aDataStream [

	triggersToTriggerAfterDataPointRegistration 
		at: aDataStream 
		ifPresent: [ :registeredTriggers | registeredTriggers add: aTrigger ] 
		ifAbsentPut: (OrderedCollection with: aTrigger)
]

{ #category : #'private - managing' }
TriggerManagementSystem >> register: aTrigger toTriggerPeriodicallyEvery: aTimePeriod [

	triggersToTriggerPeriodically
		at: aTimePeriod
		ifPresent: [ :registeredTriggers | registeredTriggers add: aTrigger ]
		ifAbsentPut: (OrderedCollection with: aTrigger)
]

{ #category : #'private - managing' }
TriggerManagementSystem >> registerIdentifierFor: anActionTrigger [ 

	identifierSystem registerIdentifierFor: anActionTrigger
]

{ #category : #'private - managing' }
TriggerManagementSystem >> registerRegistrationTimestampFor: anActionTrigger [ 
	
	metadataSystem
		register:
			(Metadata
				attaching: timeSystem dateTime
				as: #registration_timestamp
				of: anActionTrigger)
]

{ #category : #'private - dependency resolution' }
TriggerManagementSystem >> resolveDependecies [

	timeSystem := self resolveSystemDependencyTo: #TimeSystemInterface.
	eventNotificationSystem := self
		resolveSystemDependencyTo: #EventNotificationSystemInterface.
	metadataSystem := self resolveSystemDependencyTo: #MetadataSystemInterface.
	identifierSystem := self resolveSystemDependencyTo: #IdentifierSystemInterface
]

{ #category : #'starting - stopping' }
TriggerManagementSystem >> startUp [

	super startUp.
	self subscribeToDataPointRegistrationEvents .
	self subscribeToTickEvents 
]

{ #category : #'private - subscribing' }
TriggerManagementSystem >> subscribeToDataPointRegistrationEvents [

	eventNotificationSystem
		subscribe: self
		to: DataPointRegistrationEvent
		toBeNotifiedSending: #dataPointRegisteredOn:
]

{ #category : #'private - subscribing' }
TriggerManagementSystem >> subscribeToTickEvents [

	eventNotificationSystem
		subscribe: self
		to: TickEvent
		toBeNotifiedSending: #havePassed:
]

{ #category : #'private - querying' }
TriggerManagementSystem >> triggerNamed: aName ifFound: aFoundBlock ifNone: aNoneBlock [

	^ triggers
		detect: [ :trigger | trigger name = aName ]
		ifFound: aFoundBlock
		ifNone: aNoneBlock
]

{ #category : #'private - accessing' }
TriggerManagementSystem >> triggeringContext [
	
	^ TriggeringContext providing: timeSystem dateTime
]

{ #category : #querying }
TriggerManagementSystem >> triggers [

	^ triggers copy
]

{ #category : #'private - querying' }
TriggerManagementSystem >> triggersToTriggerAfterDataPointRegistrationOn: aDataStream [

	^ triggersToTriggerAfterDataPointRegistration
		at: aDataStream
		ifAbsent: [ #() ]
]

{ #category : #'private - querying' }
TriggerManagementSystem >> triggersToTriggerPeriodicallyEvery: aTimePeriod [

	^ triggersToTriggerPeriodically
		at: aTimePeriod 
		ifAbsent: [ #() ]
]
