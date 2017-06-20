adding
add: aDatapoint

	currentValue := Binding to: aDatapoint value.
	lastUpdate := Binding to: aDatapoint timestamp.

	^ dataPoints add: aDatapoint