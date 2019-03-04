Extension { #name : #TestAsserter }

{ #category : #'*Cosmos-Tests' }
TestAsserter >> assert: referenceSequenceableCollection hasSameElementsInOrderAs: sequenceableCollectionToCompare [

	self
		assert: referenceSequenceableCollection isSequenceable;
		assert: sequenceableCollectionToCompare isSequenceable;
		assert: referenceSequenceableCollection size equals: sequenceableCollectionToCompare size.

	referenceSequenceableCollection
		with: sequenceableCollectionToCompare
		do: [ :firstElement :secondElement | self assert: firstElement equals: secondElement ]
]
