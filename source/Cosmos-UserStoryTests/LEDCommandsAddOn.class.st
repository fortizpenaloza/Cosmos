Class {
	#name : #LEDCommandsAddOn,
	#superclass : #Object,
	#instVars : [
		'rootSystem'
	],
	#category : 'Cosmos-UserStoryTests'
}

{ #category : #'instance creation' }
LEDCommandsAddOn class >> on: aCompositeSystem [ 

	^self new initializeOn: aCompositeSystem 
]

{ #category : #accessing }
LEDCommandsAddOn class >> turnOffLedCommand [

	^ 'TURN_OFF_LED'
]

{ #category : #accessing }
LEDCommandsAddOn class >> turnOnLedCommand [

	^ 'TURN_ON_LED'
]

{ #category : #systems }
LEDCommandsAddOn >> commandManagementSystem [

	^ rootSystem systemImplementing: #CommandManagementSystemInterface
]

{ #category : #'initialize-release' }
LEDCommandsAddOn >> initializeOn: aCompositeSystem [ 
	
	rootSystem := aCompositeSystem 
]

{ #category : #installing }
LEDCommandsAddOn >> install [

	self commandManagementSystem
		enqueue: self class turnOnLedCommand
		with: 100
]
