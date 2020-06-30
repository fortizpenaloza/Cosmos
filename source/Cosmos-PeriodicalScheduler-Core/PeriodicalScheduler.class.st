Class {
	#name : #PeriodicalScheduler,
	#superclass : #Object,
	#instVars : [
		'scheduledTasks',
		'runningProcesses',
		'delaySchedulerOptional'
	],
	#category : #'Cosmos-PeriodicalScheduler-Core'
}

{ #category : #'instance creation' }
PeriodicalScheduler class >> usingDefaultScheduler [

	^ self workingWithOptional: Optional unused
]

{ #category : #'instance creation' }
PeriodicalScheduler class >> workingWith: aDelayScheduler [

	^ self workingWithOptional: ( Optional containing: aDelayScheduler )
]

{ #category : #'instance creation' }
PeriodicalScheduler class >> workingWithOptional: aDelaySchedulerOptional [

	^ self new initializeWorkingWith: aDelaySchedulerOptional
]

{ #category : #scheduling }
PeriodicalScheduler >> durationFrom: aTimePeriod [

	^ Duration milliSeconds: (aTimePeriod convertTo: TimeUnits millisecond) amount
]

{ #category : #'initialize-release' }
PeriodicalScheduler >> initializeWorkingWith: aDelaySchedulerOptional [ 

	delaySchedulerOptional := aDelaySchedulerOptional.
	scheduledTasks := OrderedCollection new.
	runningProcesses := WeakSet new.
]

{ #category : #scheduling }
PeriodicalScheduler >> schedule: aScheduledTask [

	| process |

	process := [ | delay |

	delay := Delay forDuration: ( self durationFrom: aScheduledTask timePeriod ).
	delaySchedulerOptional withContentDo: [ :delayScheduler | delayScheduler schedule: delay ].
	delay wait.
	aScheduledTask execute.
	self schedule: aScheduledTask
	] newProcess.

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

{ #category : #controlling }
PeriodicalScheduler >> start [

	scheduledTasks do: [ :scheduledTask | self schedule: scheduledTask ]
]

{ #category : #controlling }
PeriodicalScheduler >> stop [

	runningProcesses do: [ :process | process terminate ]
]
