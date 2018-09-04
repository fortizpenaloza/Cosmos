Class {
	#name : #PriorityQueueTest,
	#superclass : #TestCase,
	#category : #'Cosmos-Commands-Tests'
}

{ #category : #tests }
PriorityQueueTest >> highestPriority [

	^ 100
]

{ #category : #tests }
PriorityQueueTest >> lowestPriority [

	^ 1
]

{ #category : #tests }
PriorityQueueTest >> mediumPriority [

	^ 50
]

{ #category : #tests }
PriorityQueueTest >> testDequeuingFailsWhenQueueIsEmpty [

	| priorityQueue |

	priorityQueue := PriorityQueue empty.
	self
		should: [ priorityQueue dequeue ]
		raise: CollectionIsEmpty 
		withDescription: 'a SortedCollection() is empty'
]

{ #category : #tests }
PriorityQueueTest >> testDequeuingRepectsEnqueuingOrderWhenQueueHasElementsWithSamePriority [

	| priorityQueue |

	priorityQueue := PriorityQueue empty.
	priorityQueue enqueue: 'a' with: self lowestPriority.
	priorityQueue enqueue: 'b' with: self lowestPriority.
	priorityQueue enqueue: 'c' with: self highestPriority.
	priorityQueue enqueue: 'd' with: self highestPriority.

	self assert: priorityQueue dequeue equals: 'c'.
	self assert: priorityQueue dequeue equals: 'd'.
	self assert: priorityQueue dequeue equals: 'a'.
	self assert: priorityQueue dequeue equals: 'b'
]

{ #category : #tests }
PriorityQueueTest >> testDequeuingRespectsEnqueuedElementPriority [

	| priorityQueue |

	priorityQueue := PriorityQueue empty.
	priorityQueue enqueue: 'a' with: self lowestPriority.
	priorityQueue enqueue: 'b' with: self mediumPriority.
	priorityQueue enqueue: 'c' with: self highestPriority.

	self assert: priorityQueue dequeue equals: 'c'.
	self assert: priorityQueue dequeue equals: 'b'.
	self assert: priorityQueue dequeue equals: 'a'
]

{ #category : #tests }
PriorityQueueTest >> testIsEmptyAfterCreation [

	| priorityQueue |

	priorityQueue := PriorityQueue empty.
	self assert: priorityQueue isEmpty
]
