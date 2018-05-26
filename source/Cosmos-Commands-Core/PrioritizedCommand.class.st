"
I'm a prioritized command.

I know a command, the exactly date and time i was prioritized and with wich priority,
"
Class {
	#name : #PrioritizedCommand,
	#superclass : #Object,
	#instVars : [
		'command',
		'priority',
		'prioritizationDateTime'
	],
	#category : 'Cosmos-Commands-Core-SystemModel'
}

{ #category : #'instance creation' }
PrioritizedCommand class >> holding: aCommand with: aPriority on: aDateTime [ 
	
	^ self new initializeHolding: aCommand with: aPriority on: aDateTime
]

{ #category : #comparing }
PrioritizedCommand >> = anObject [

	^ self == anObject
		or: [ (self class = anObject class)
				and: [ command = anObject command
						and: [ priority = anObject priority
								and: [ prioritizationDateTime = anObject prioritizationDateTime ] ] ] ]
]

{ #category : #accessing }
PrioritizedCommand >> command [

	^ command
]

{ #category : #comparing }
PrioritizedCommand >> hash [

	^ command hash bitXor: (priority hash bitXor: prioritizationDateTime hash)
]

{ #category : #'initialize-release' }
PrioritizedCommand >> initializeHolding: aCommand with: aPriority on: aDateTime [

	command := aCommand.
	priority := aPriority.
	prioritizationDateTime := aDateTime 
]

{ #category : #accessing }
PrioritizedCommand >> prioritizationDateTime [
	
	^ prioritizationDateTime
]

{ #category : #accessing }
PrioritizedCommand >> priority [
	
	^ priority
]
