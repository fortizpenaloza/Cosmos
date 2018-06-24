Class {
	#name : #LowPriority,
	#superclass : #QueuePriority,
	#category : #'Cosmos-Commands-Model'
}

{ #category : #'pushing-popping' }
LowPriority >> enqueue: aCommand into: aPriorityQueue [ 

	aPriorityQueue enqueueWithLowPriority: aCommand 
]
