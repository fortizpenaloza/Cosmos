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

{ #category : #systems }
SensorsSampleAddOn >> dataManagementSystem [

	^ rootSystem systemImplementing: #DataManagementSystemInterface
]

{ #category : #'initialize-release' }
SensorsSampleAddOn >> initializeOn: aCompositeSystem [ 
	
	rootSystem := aCompositeSystem 
]

{ #category : #installing }
SensorsSampleAddOn >> install [

	| temperatureStream atmosphericPressureStream humidityStream |

	temperatureStream := self dataManagementSystem
		registerStreamNamed: 'Temperature'.
	atmosphericPressureStream := self dataManagementSystem
		registerStreamNamed: 'Pressure'.
	humidityStream := self dataManagementSystem
		registerStreamNamed: 'Humidity'.
	self dataManagementSystem
		register: 15.5
		toStreamNamed: temperatureStream name.
	self dataManagementSystem
		register: 16
		toStreamNamed: temperatureStream name.
	self dataManagementSystem
		register: 1016
		toStreamNamed: atmosphericPressureStream name.
	self dataManagementSystem
		register: 72
		toStreamNamed: humidityStream name
]
