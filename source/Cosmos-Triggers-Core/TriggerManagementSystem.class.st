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
		'triggers',
		'triggersToTriggerPeriodically',
		'triggersToTriggerAfterDataPointRegistration'
	],
	#category : 'Cosmos-Triggers-Core-SystemModel'
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

{ #category : #'private-managing' }
TriggerManagementSystem >> deregister: aTrigger accordingTo: aTriggeringPolicy [ 

	aTriggeringPolicy deregister: aTrigger from: self.
	triggers remove: aTrigger
]

{ #category : #'private-managing' }
TriggerManagementSystem >> deregister: aTrigger fromTriggeredPeriodicallyEvery: aTimePeriod [ 

	(self triggersToTriggerPeriodicallyEvery: aTimePeriod) remove: aTrigger 
]

{ #category : #'private-managing' }
TriggerManagementSystem >> deregister: aTrigger toStopTriggeringAfterDataPointRegistrationOn: aDataStream [ 
	
	(self triggersToTriggerAfterDataPointRegistrationOn: aDataStream) remove: aTrigger 	
]

{ #category : #managing }
TriggerManagementSystem >> deregisterNamed: aName [

	self
		triggerNamed: aName
		ifFound: [ :trigger | self deregister: trigger accordingTo: trigger triggeringPolicy ]
		ifNone: [ ObjectNotFoundInSystem signal: 'Trigger not found in system' ]
]

{ #category : #'events handling' }
TriggerManagementSystem >> havePassed: aTickEvent [

	Transcript show: 'aca estoy'.
	
	(self triggersToTriggerPeriodicallyEvery: aTickEvent timePeriod)
		do: [ :trigger | 
			trigger
				ifSatisfiedOn: self triggeringContext
				withActionDo: [ :action | self notifyEvaluationOf: action ] ]
]

{ #category : #'initialize-release' }
TriggerManagementSystem >> initialize [

	super initialize.
	eventNotificationSystem := self unresolvedSystemDependencyTo: #EventNotificationSystemInterface.
	timeSystem := self unresolvedSystemDependencyTo: #TimeSystemInterface.

	triggers := OrderedCollection new.
	triggersToTriggerAfterDataPointRegistration := Dictionary new.
	triggersToTriggerPeriodically := Dictionary new
]

{ #category : #'events handling' }
TriggerManagementSystem >> notifyEvaluationOf: action [

	^ eventNotificationSystem notifySubscribersTo: (EvaluateActionEvent of: action)
]

{ #category : #'private-managing' }
TriggerManagementSystem >> register: aTrigger accordingTo: aTriggeringPolicy [

	triggers add: aTrigger.	
	aTriggeringPolicy register: aTrigger to: self.
	
]

{ #category : #'private-managing' }
TriggerManagementSystem >> register: aTrigger toTriggerAfterDataPointRegistrationOn: aDataStream [

	triggersToTriggerAfterDataPointRegistration 
		at: aDataStream 
		ifPresent: [ :registeredTriggers | registeredTriggers add: aTrigger ] 
		ifAbsentPut: (OrderedCollection with: aTrigger)
]

{ #category : #'private-managing' }
TriggerManagementSystem >> register: aTrigger toTriggerPeriodicallyEvery: aTimePeriod [

	triggersToTriggerPeriodically
		at: aTimePeriod
		ifPresent: [ :registeredTriggers | registeredTriggers add: aTrigger ]
		ifAbsentPut: (OrderedCollection with: aTrigger)
]

{ #category : #'private-managing' }
TriggerManagementSystem >> registerNamed: aName triggering: anAction accordingTo: aTriggeringPolicy whenMeets: aTriggeringCondition [

	^ self
		triggerNamed: aName
		ifFound: [ :trigger | 
			ObjectAlreadyInSystem
				signal: 'Trigger with that name already exists in system' ]
		ifNone: [ | trigger |

			trigger := ActionTrigger
				named: aName
				createdOn: timeSystem dateTime
				triggering: anAction
				accordingTo: aTriggeringPolicy
				ifSatisfies: aTriggeringCondition.

			self register: trigger accordingTo: aTriggeringPolicy.

			trigger ]
]

{ #category : #managing }
TriggerManagementSystem >> registerNamed: aName triggering: anAction afterDataPointWasRegisteredOn: aDataStream ifSatisfies: aTriggeringCondition [

	^ self
		registerNamed: aName
		triggering: anAction
		accordingTo: (DataPointRegistrationTriggeringPolicy on: aDataStream)
		whenMeets: aTriggeringCondition
]

{ #category : #managing }
TriggerManagementSystem >> registerNamed: aName triggering: anAction periodicallyEvery: aTimePeriod ifSatisfies: aTriggeringCondition [

	^ self
		registerNamed: aName
		triggering: anAction
		accordingTo: (PeriodicalTriggeringPolicy every: aTimePeriod)
		whenMeets: aTriggeringCondition
]

{ #category : #'dependency resolution' }
TriggerManagementSystem >> resolveDependecies [

	timeSystem := self resolveSystemDependencyTo: #TimeSystemInterface.
	eventNotificationSystem := self
		resolveSystemDependencyTo: #EventNotificationSystemInterface.

	eventNotificationSystem
		subscribe: self
		to: DataPointRegistrationEvent
		toBeNotifiedSending: #dataPointRegisteredOn:.
	
	eventNotificationSystem subscribe: self to: TickEvent toBeNotifiedSending: #havePassed:
]

{ #category : #'private-querying' }
TriggerManagementSystem >> triggerNamed: aName ifFound: aFoundBlock ifNone: aNoneBlock [

	^ triggers
		detect: [ :trigger | trigger name = aName ]
		ifFound: aFoundBlock
		ifNone: aNoneBlock
]

{ #category : #'private-accessing' }
TriggerManagementSystem >> triggeringContext [
	
	^ TriggeringContext providing: timeSystem dateTime
]

{ #category : #querying }
TriggerManagementSystem >> triggers [

	^ triggers copy
]

{ #category : #'private-querying' }
TriggerManagementSystem >> triggersToTriggerAfterDataPointRegistrationOn: aDataStream [

	^ triggersToTriggerAfterDataPointRegistration
		at: aDataStream
		ifAbsent: [ #() ]
]

{ #category : #'private-querying' }
TriggerManagementSystem >> triggersToTriggerPeriodicallyEvery: aTimePeriod [

	^ triggersToTriggerPeriodically
		at: aTimePeriod 
		ifAbsent: [ #() ]
]
