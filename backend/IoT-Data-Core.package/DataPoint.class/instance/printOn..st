printing
printOn: aStream 	
	
	timestamp printOn: aStream.
	aStream nextPut: $-.
	value printOn: aStream
	