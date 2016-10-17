as yet unclassified
addSensorsSampleData

	| dataChannel temperatureStream atmosphericPressureStream humidityStream |

	dataChannel := self dataManagementSystem registerChannelNamed: 'Sensors #1'.
	temperatureStream := self dataManagementSystem
		registerStreamNamed: 'Temperature'
		toChannelIdentifiedBy: dataChannel identifier.
	atmosphericPressureStream := self dataManagementSystem
		registerStreamNamed: 'Pressure'
		toChannelIdentifiedBy: dataChannel identifier.
	humidityStream := self dataManagementSystem
		registerStreamNamed: 'Humidity'
		toChannelIdentifiedBy: dataChannel identifier.
	self dataManagementSystem
		register: 16
		toStreamNamed: temperatureStream name
		ofChannelIdentifiedBy: dataChannel identifier.
	self dataManagementSystem
		register: 1016
		toStreamNamed: atmosphericPressureStream name
		ofChannelIdentifiedBy: dataChannel identifier.
	self dataManagementSystem
		register: 72
		toStreamNamed: humidityStream name
		ofChannelIdentifiedBy: dataChannel identifier