Class {
	#name : #PriorityQueueTest,
	#superclass : #TestCase,
	#category : 'Cosmos-Commands-Tests-Model'
}

{ #category : #tests }
PriorityQueueTest >> testDequeuingFailsWhenQueueIsEmpty [

	| priorityQueue |

	priorityQueue := PriorityQueue empty.
	self should: [ priorityQueue dequeue ] raise: QueueIsEmpty withDescription: 'Queue is empty'
]

{ #category : #tests }
PriorityQueueTest >> testDequeuingRepectsEnqueuingOrderWhenQueueHasElementsWithSamePriority [

	| priorityQueue |

	priorityQueue := PriorityQueue empty.
	priorityQueue enqueue: 2 with: QueuePriority low.
	priorityQueue enqueue: 3 with: QueuePriority low.
	priorityQueue enqueue: 4 with: QueuePriority high.
	priorityQueue enqueue: 5 with: QueuePriority high.

	self assert: priorityQueue dequeue equals: 4.
	self assert: priorityQueue dequeue equals: 5.
	self assert: priorityQueue dequeue equals: 2.
	self assert: priorityQueue dequeue equals: 3
]

{ #category : #tests }
PriorityQueueTest >> testDequeuingRespectsEnqueuedElementPriority [

	| priorityQueue |

	priorityQueue := PriorityQueue empty.
	priorityQueue enqueue: 2 with: QueuePriority low.
	priorityQueue enqueue: 3 with: QueuePriority medium.
	priorityQueue enqueue: 4 with: QueuePriority high.

	self assert: priorityQueue dequeue equals: 4.
	self assert: priorityQueue dequeue equals: 3.
	self assert: priorityQueue dequeue equals: 2
]

{ #category : #tests }
PriorityQueueTest >> testIsEmptyAfterCreation [

	| priorityQueue |

	priorityQueue := PriorityQueue empty.
	self assert: priorityQueue isEmpty
]
