private-formatting
put: aNumber paddedLeftToTwoWithZeroOn: aStream

	aStream nextPutAll: (aNumber asString padLeftTo: 2 with: $0)