private-formatting
putTimeOf: aDateTime on: stream

	stream nextPutAll: (timeOfDayFormatter format: aDateTime timeOfDay)