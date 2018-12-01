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

{ #category : #accessing }
SensorsSampleAddOn >> currentDateTime [

	^ self timeSystem dateTime
]

{ #category : #'private - systems' }
SensorsSampleAddOn >> dataManagementSystem [

	^ cosmos systemImplementing: #DataStreamManagementSystemInterface
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

	self registerStreamNamed: 'Pressure'.
	
	self dataManagementSystem
		register: (DataPoint on: self currentDateTime holding: 1016)
		toStreamNamed: 'Pressure'
]

{ #category : #'private - installing' }
SensorsSampleAddOn >> registerHumidityStreamWithoutDataPoints [

	self registerStreamNamed: 'Humidity'
]

{ #category : #'private - installing' }
SensorsSampleAddOn >> registerStreamNamed: aName [

	| dataStream |

	dataStream := DataStream named: aName.
	self dataManagementSystem register: dataStream
]

{ #category : #'private - installing' }
SensorsSampleAddOn >> registerTemperatureStreamWithSomeDataPoints [

	self registerStreamNamed: 'Temperature'.

	self dataManagementSystem
		register: (DataPoint on: self currentDateTime holding: 15.5)
		toStreamNamed: 'Temperature'.

	self dataManagementSystem
		register: (DataPoint on: self currentDateTime holding: 16)
		toStreamNamed: 'Temperature'.
		
	self dataManagementSystem
		register: (DataPoint on: self currentDateTime holding: 16.5)
		toStreamNamed: 'Temperature'
]

{ #category : #'private - systems' }
SensorsSampleAddOn >> timeSystem [

	^ cosmos systemImplementing: #TimeSystemInterface
]
