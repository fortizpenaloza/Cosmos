Class {
	#name : #MediumPriority,
	#superclass : #QueuePriority,
	#category : #'Cosmos-Commands-Model'
}

{ #category : #'pushing-popping' }
MediumPriority >> enqueue: aCommand into: aPriorityQueue [ 

	aPriorityQueue enqueueWithMediumPriority: aCommand 
]
