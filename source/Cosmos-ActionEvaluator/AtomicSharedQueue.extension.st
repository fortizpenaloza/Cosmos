Extension { #name : #AtomicSharedQueue }

{ #category : #'*Cosmos-ActionEvaluator' }
AtomicSharedQueue >> dequeue [
	
	^ self next
]

{ #category : #'*Cosmos-ActionEvaluator' }
AtomicSharedQueue >> enqueue: anElement [

	self nextPut: anElement
]
