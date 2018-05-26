Class {
	#name : #LowPriority,
	#superclass : #QueuePriority,
	#category : 'Cosmos-Commands-Core-Model'
}

{ #category : #'pushing-popping' }
LowPriority >> enqueue: aCommand into: aPriorityQueue [ 

	aPriorityQueue enqueueWithLowPriority: aCommand 
]
