Class {
	#name : #PriorityQueue,
	#superclass : #Object,
	#instVars : [
		'lowPrioritizedElements',
		'mediumPrioritizedElements',
		'highPrioritizedElements'
	],
	#category : #'Cosmos-Commands-Model'
}

{ #category : #'instance creation' }
PriorityQueue class >> empty [
	
	^ super new initialize 
]

{ #category : #'enqueuing-dequeiung' }
PriorityQueue >> dequeue [

	^ highPrioritizedElements
		ifEmpty: [ mediumPrioritizedElements
				ifEmpty: [ lowPrioritizedElements
						ifEmpty: [ QueueIsEmpty signal: 'Queue is empty' ]
						ifNotEmpty: [ :collection | collection removeFirst ] ]
				ifNotEmpty: [ :collection | collection removeFirst ] ]
		ifNotEmpty: [ :collection | collection removeFirst ]
]

{ #category : #'enqueuing-dequeiung' }
PriorityQueue >> enqueue: anElement with: aPriority [ 

	aPriority enqueue: anElement into: self
]

{ #category : #'enqueuing-dequeiung' }
PriorityQueue >> enqueueWithHighPriority: anElementWithPriority [ 

	highPrioritizedElements add: anElementWithPriority 
]

{ #category : #'enqueuing-dequeiung' }
PriorityQueue >> enqueueWithLowPriority: anElementWithPriority [ 
	
	lowPrioritizedElements add: anElementWithPriority 
]

{ #category : #'enqueuing-dequeiung' }
PriorityQueue >> enqueueWithMediumPriority: anElementWithPriority [ 
	
	mediumPrioritizedElements add: anElementWithPriority 
]

{ #category : #'initialize-release' }
PriorityQueue >> initialize [

	lowPrioritizedElements := OrderedCollection new.
	mediumPrioritizedElements := OrderedCollection new.
	highPrioritizedElements := OrderedCollection new
]

{ #category : #testing }
PriorityQueue >> isEmpty [

	^ (Array
		with: lowPrioritizedElements
		with: mediumPrioritizedElements
		with: highPrioritizedElements) allSatisfy: [ :collection | collection isEmpty ]
]
