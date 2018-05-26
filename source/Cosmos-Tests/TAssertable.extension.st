Extension { #name : #TAssertable }

{ #category : #'*Cosmos-Tests' }
TAssertable >> assert: aSequenceableCollection hasTheSameElementsInTheSameOrderThat: anotherSequenceableCollection [

	self assert: aSequenceableCollection isSequenceable; 
		assert: anotherSequenceableCollection isSequenceable; 
		assert: aSequenceableCollection size equals: anotherSequenceableCollection size.
		
	aSequenceableCollection
		with: anotherSequenceableCollection
		do: [ :firstElement :secondElement | self assert: firstElement equals: secondElement ]
]

{ #category : #'*Cosmos-Tests' }
TAssertable >> should: aBlock raise: anException withDescription: aDescription [

	^ self
		should: aBlock
		raise: anException
		withExceptionDo: [ :signal | self assert: signal messageText equals: aDescription ]
]

{ #category : #'*Cosmos-Tests' }
TAssertable >> withTheOnlyOneIn: aCollection do: aBlock [

	self assert: aCollection size equals: 1.
	aBlock value: aCollection first
]
