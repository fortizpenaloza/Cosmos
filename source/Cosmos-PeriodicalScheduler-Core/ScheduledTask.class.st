Class {
	#name : #ScheduledTask,
	#superclass : #Object,
	#instVars : [
		'task',
		'timePeriod'
	],
	#category : 'Cosmos-PeriodicalScheduler-Core-Cosmos-PeriodicalScheduler-Core'
}

{ #category : #'instance creation' }
ScheduledTask class >> executing: aTask every: aTimePeriod [ 

	^self new initializeExecuting: aTask every: aTimePeriod 
]

{ #category : #executing }
ScheduledTask >> execute [
	
	task execute
]

{ #category : #'initialize-release' }
ScheduledTask >> initializeExecuting: aTask every: aTimePeriod [ 
	
	task := aTask.
	timePeriod := aTimePeriod 
]

{ #category : #accessing }
ScheduledTask >> name [

	^ task name
]

{ #category : #accessing }
ScheduledTask >> timePeriod [

	^ timePeriod
]
