*Cosmos-PeriodicalScheduler-Tests
assert: aSequenceableCollection hasTheSameElementsInTheSameOrderThat: anotherSequenceableCollection

	self assert: aSequenceableCollection isSequenceable; 
		assert: anotherSequenceableCollection isSequenceable; 
		assert: aSequenceableCollection size equals: anotherSequenceableCollection size.
		
	aSequenceableCollection
		with: anotherSequenceableCollection
		do: [ :firstElement :secondElement | self assert: firstElement equals: secondElement ]