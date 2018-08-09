Class {
	#name : #SensorsSampleAddOn,
	#superclass : #Object,
	#instVars : [
		'rootSystem'
	],
	#category : 'Cosmos-UserStoryTests'
}

{ #category : #'instance creation' }
SensorsSampleAddOn class >> on: aCompositeSystem [ 

	^self new initializeOn: aCompositeSystem 
]

{ #category : #accessing }
SensorsSampleAddOn >> currentDateTime [

	^ self timeSystem dateTime
]

{ #category : #'private - systems' }
SensorsSampleAddOn >> dataManagementSystem [

	^ rootSystem systemImplementing: #DataManagementSystemInterface
]

{ #category : #initialization }
SensorsSampleAddOn >> initializeOn: aCompositeSystem [ 
	
	rootSystem := aCompositeSystem 
]

{ #category : #installing }
SensorsSampleAddOn >> install [

	| temperatureStream atmosphericPressureStream humidityStream |

	temperatureStream := DataStream
		named: 'Temperature'
		createdOn: self currentDateTime.
	self dataManagementSystem register: temperatureStream.
	
	atmosphericPressureStream := DataStream
		named: 'Pressure'
		createdOn: self currentDateTime.
	self dataManagementSystem register: atmosphericPressureStream.
	
	humidityStream := DataStream 
		named: 'Humidity' 
		createdOn: self currentDateTime.
	self dataManagementSystem register: humidityStream.

	self dataManagementSystem
		register: (DataPoint on: self currentDateTime holding: 15.5)
		toStreamNamed: temperatureStream name.
	self dataManagementSystem
		register: (DataPoint on: self currentDateTime holding: 16)
		toStreamNamed: temperatureStream name.
	self dataManagementSystem
		register: (DataPoint on: self currentDateTime holding: 1016)
		toStreamNamed: atmosphericPressureStream name.
	self dataManagementSystem
		register: (DataPoint on: self currentDateTime holding: 72)
		toStreamNamed: humidityStream name
]

{ #category : #'private - systems' }
SensorsSampleAddOn >> timeSystem [

	^ rootSystem systemImplementing: #TimeSystemInterface
]
