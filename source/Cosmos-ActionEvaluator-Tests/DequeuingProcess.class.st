Class {
	#name : #DequeuingProcess,
	#superclass : #Object,
	#instVars : [
		'process'
	],
	#category : #'Cosmos-ActionEvaluator-Tests'
}

{ #category : #'instance creation' }
DequeuingProcess class >> named: aName from: aQueue applying: aBlock [

	^ self new initializeNamed: aName from: aQueue applying: aBlock
]

{ #category : #initialization }
DequeuingProcess >> initializeNamed: aName from: aQueue applying: aBlock [

	process := [ [ aBlock value: aQueue next ] repeat ] newProcess.

	process
		name: aName;
		priority: Processor userBackgroundPriority + 1
]

{ #category : #controlling }
DequeuingProcess >> start [
	
	process resume
]

{ #category : #controlling }
DequeuingProcess >> stop [

	process terminate
]
