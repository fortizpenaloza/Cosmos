Extension { #name : #TestCase }

{ #category : #'*Cosmos-Tests' }
TestCase >> assert: referenceSequenceableCollection hasTheSameElementsInTheSameOrderThat: sequenceableCollectionToCompare [

	self
		assert: referenceSequenceableCollection isSequenceable;
		assert: sequenceableCollectionToCompare isSequenceable;
		assert: referenceSequenceableCollection size equals: sequenceableCollectionToCompare size.

	referenceSequenceableCollection
		with: sequenceableCollectionToCompare
		do: [ :firstElement :secondElement | self assert: firstElement equals: secondElement ]
]

{ #category : #'*Cosmos-Tests' }
TestCase >> should: aBlock raise: anException withDescription: aDescription [

	^ self
		should: aBlock
		raise: anException
		withExceptionDo: [ :signal | self assert: signal messageText equals: aDescription ]
]

{ #category : #'*Cosmos-Tests' }
TestCase >> withTheOnlyOneIn: aCollection do: aBlock [

	self assert: aCollection size equals: 1.
	aBlock value: aCollection anyOne
]
