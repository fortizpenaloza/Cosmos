Class {
	#name : #Task,
	#superclass : #Object,
	#instVars : [
		'name',
		'block'
	],
	#category : 'Cosmos-PeriodicalScheduler-Core-Cosmos-PeriodicalScheduler-Core'
}

{ #category : #'instance creation' }
Task class >> named: aName do: aBlock [ 

	^ self new initializeNamed: aName do: aBlock
]

{ #category : #executing }
Task >> execute [
	
	^ block value
]

{ #category : #'initialize-release' }
Task >> initializeNamed: aName do: aBlock [ 

	name := aName.
	block := aBlock
]

{ #category : #accessing }
Task >> name [

	^ name
]
