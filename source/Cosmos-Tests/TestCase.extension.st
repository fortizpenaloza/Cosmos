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
