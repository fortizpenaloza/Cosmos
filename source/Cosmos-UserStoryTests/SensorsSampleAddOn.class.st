Class {
	#name : #SensorsSampleAddOn,
	#superclass : #Object,
	#instVars : [
		'cosmos'
	],
	#category : #'Cosmos-UserStoryTests'
}

{ #category : #'instance creation' }
SensorsSampleAddOn class >> on: aCosmosSystem [ 

	^self new initializeOn: aCosmosSystem 
]

{ #category : #'private - systems' }
SensorsSampleAddOn >> dataManagementSystem [

	^ cosmos >> #DataStreamManagementSystemInterface
]

{ #category : #accessing }
SensorsSampleAddOn >> dateTime [

	^ self timeSystem dateTime
]

{ #category : #initialization }
SensorsSampleAddOn >> initializeOn: aCosmosSystem [ 
	
	cosmos := aCosmosSystem 
]

{ #category : #installing }
SensorsSampleAddOn >> install [

	self
		registerTemperatureStreamWithSomeDataPoints;
		registerAtmosphoricPressureStreamWithOneDataPoint;
		registerHumidityStreamWithoutDataPoints
]

{ #category : #'private - installing' }
SensorsSampleAddOn >> registerAtmosphoricPressureStreamWithOneDataPoint [

	| pressure |

	pressure := self registerStreamNamed: 'Pressure'.

	self dataManagementSystem register: ( DataPoint on: self dateTime holding: 1016 ) to: pressure
]

{ #category : #'private - installing' }
SensorsSampleAddOn >> registerHumidityStreamWithoutDataPoints [

	self registerStreamNamed: 'Humidity'
]

{ #category : #'private - installing' }
SensorsSampleAddOn >> registerStreamNamed: aName [

	^ self dataManagementSystem register: ( DataStream named: aName )
]

{ #category : #'private - installing' }
SensorsSampleAddOn >> registerTemperatureStreamWithSomeDataPoints [

	| temperature |

	temperature := self registerStreamNamed: 'Temperature'.

	self dataManagementSystem register: ( DataPoint on: self dateTime holding: 15.5 ) to: temperature.

	self dataManagementSystem register: ( DataPoint on: self dateTime holding: 16 ) to: temperature.

	self dataManagementSystem register: ( DataPoint on: self dateTime holding: 16.5 ) to: temperature
]

{ #category : #'private - systems' }
SensorsSampleAddOn >> timeSystem [

	^ cosmos >> #TimeSystemInterface
]
