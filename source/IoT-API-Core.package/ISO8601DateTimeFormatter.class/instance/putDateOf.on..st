private-formatting
putDateOf: aDateTime on: stream

	stream nextPutAll: (dateFormatter format: aDateTime date)