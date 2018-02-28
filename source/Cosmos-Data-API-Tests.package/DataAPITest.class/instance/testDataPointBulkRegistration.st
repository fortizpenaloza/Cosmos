tests
testDataPointBulkRegistration

	| interface response temperature pressure |

	temperature := self temperatureStream.
	pressure := self pressureStream.

	self assert: temperature currentValue ~= 24.
	self assert: pressure currentValue ~= 89.

	interface := DataAPI workingWith: rootSystem.
	response := interface registerBulkPointsFrom: self updateTemperatureAndPressureDataStreamsJSON.

	self assert: response code equals: 201.

	self assert: temperature currentValue = 24.
	self assert: pressure currentValue = 89