Class {
	#name : #MediumPriority,
	#superclass : #QueuePriority,
	#category : 'Cosmos-Commands-Core-Model'
}

{ #category : #'pushing-popping' }
MediumPriority >> enqueue: aCommand into: aPriorityQueue [ 

	aPriorityQueue enqueueWithMediumPriority: aCommand 
]
