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

	^ rootSystem >> #CommandManagementSystemInterface
]

{ #category : #initialization }
LEDCommandsAddOn >> initializeOn: aCompositeSystem [ 
	
	rootSystem := aCompositeSystem 
]

{ #category : #installing }
LEDCommandsAddOn >> install [

	self commandManagementSystem
		register: (CommandWithPriority holding: self class turnOnLedCommand and: 1).

	self commandManagementSystem
		register: (CommandWithPriority holding: self class turnOnLedCommand and: 100).
		
	self commandManagementSystem
		register: (CommandWithPriority holding: self class turnOffLedCommand and: 50)
]
