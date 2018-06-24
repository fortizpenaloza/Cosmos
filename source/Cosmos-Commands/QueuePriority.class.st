Class {
	#name : #QueuePriority,
	#superclass : #Object,
	#category : #'Cosmos-Commands-Model'
}

{ #category : #'instance creation' }
QueuePriority class >> high [
	
	^ HighPriority new
]

{ #category : #'instance creation' }
QueuePriority class >> low [
	
	^ LowPriority new
]

{ #category : #'instance creation' }
QueuePriority class >> medium [
	
	^ MediumPriority new
]

{ #category : #comparing }
QueuePriority >> = anObject [

	^ self == anObject or: [ self class = anObject class ]
]

{ #category : #'pushing-popping' }
QueuePriority >> enqueue: aCommand into: aPriorityQueue [ 

	self subclassResponsibility 
]
