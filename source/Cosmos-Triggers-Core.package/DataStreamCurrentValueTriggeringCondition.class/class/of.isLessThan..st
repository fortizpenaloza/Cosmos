instance creation
of: aDataStream isLessThan: aValue

	^ self
		of: aDataStream
		comparingWith: (ArithmeticCondition toBeLessThan: aValue)