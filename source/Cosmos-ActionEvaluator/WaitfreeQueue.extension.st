Extension { #name : #WaitfreeQueue }

{ #category : #'*Cosmos-ActionEvaluator' }
WaitfreeQueue >> dequeue [
	
	^ self nextOrNil
]

{ #category : #'*Cosmos-ActionEvaluator' }
WaitfreeQueue >> enqueue: anElement [

	self nextPut: anElement
]
