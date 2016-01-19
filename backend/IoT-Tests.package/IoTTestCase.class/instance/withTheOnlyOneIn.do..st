asserting
withTheOnlyOneIn: aCollection do: aBlock
		
	self assert: aCollection size equals: 1.
	aBlock value: aCollection first