installing
install

	| temperatureStream atmosphericPressureStream humidityStream |

	temperatureStream := self dataManagementSystem
		registerStreamNamed: 'Temperature'.
	atmosphericPressureStream := self dataManagementSystem
		registerStreamNamed: 'Pressure'.
	humidityStream := self dataManagementSystem
		registerStreamNamed: 'Humidity'.
	self dataManagementSystem
		register: 16
		toStreamNamed: temperatureStream name.
	self dataManagementSystem
		register: 1016
		toStreamNamed: atmosphericPressureStream name.
	self dataManagementSystem
		register: 72
		toStreamNamed: humidityStream name