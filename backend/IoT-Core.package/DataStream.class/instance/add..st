adding
add: aDatapoint

	currentValue := ObjectBinding to: aDatapoint value.
	lastUpdate := ObjectBinding to: aDatapoint timestamp.

	^ dataPoints add: aDatapoint.