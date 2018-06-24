Class {
	#name : #HighPriority,
	#superclass : #QueuePriority,
	#category : #'Cosmos-Commands-Model'
}

{ #category : #'pushing-popping' }
HighPriority >> enqueue: aCommand into: aPriorityQueue [ 

	aPriorityQueue enqueueWithHighPriority: aCommand 
]
