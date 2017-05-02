adding
add: aDatapoint

	currentValue := BoundObject to: aDatapoint value.
	lastUpdate := BoundObject to: aDatapoint timestamp.

	^ dataPoints add: aDatapoint.