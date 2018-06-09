Class {
	#name : #PeriodicalScheduler,
	#superclass : #Object,
	#instVars : [
		'delayScheduler',
		'scheduledTasks',
		'runningProcesses'
	],
	#category : 'Cosmos-PeriodicalScheduler-Core'
}

{ #category : #'instance creation' }
PeriodicalScheduler class >> workingWith: aDelayScheduler [ 

	^self new initializeWorkingWith: aDelayScheduler 
]

{ #category : #scheduling }
PeriodicalScheduler >> durationFrom: aTimePeriod [

	^ Duration milliSeconds: (aTimePeriod convertTo: TimeUnits millisecond) amount
]

{ #category : #'initialize-release' }
PeriodicalScheduler >> initializeWorkingWith: aDelayScheduler [ 

	delayScheduler := aDelayScheduler.
	scheduledTasks := OrderedCollection new.
	runningProcesses := WeakSet new.
]

{ #category : #scheduling }
PeriodicalScheduler >> schedule: aScheduledTask [

	| process |
	process := [ | delay |
		delay := Delay forDuration: (self durationFrom: aScheduledTask timePeriod).
		delayScheduler schedule: delay.
		delay wait.
		aScheduledTask execute.
		self schedule: aScheduledTask ] newProcess.
	
	runningProcesses add: process.
	
	process
		name: aScheduledTask name;
		priority: Processor lowestPriority;
		resume.
	
	^ process
]

{ #category : #configuring }
PeriodicalScheduler >> schedule: aTask toBeExecutedEvery: aTimePeriod [

	scheduledTasks add: (ScheduledTask executing: aTask every: aTimePeriod)
	
]

{ #category : #'starting-stopping' }
PeriodicalScheduler >> start [

	scheduledTasks do: [ :scheduledTask | self schedule: scheduledTask ]
]

{ #category : #'starting-stopping' }
PeriodicalScheduler >> stop [

	runningProcesses do: [ :process | process terminate ]
]
