instance creation
of: aDataStream isLessThan: aValue

	^self of: aDataStream comparingWith: (IsLessThanCondition comparingWith: aValue)