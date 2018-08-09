"
A CosmosCommandLineHandlerTest is a test class for testing the behavior of CosmosCommandLineHandler
"
Class {
	#name : #CosmosCommandLineHandlerTest,
	#superclass : #TestCase,
	#category : #'Cosmos-CommandLineHandler-Tests'
}

{ #category : #history }
CosmosCommandLineHandlerTest class >> lastStoredRun [
	^ ((Dictionary new) add: (#timeStamp->(DateAndTime basicNew instVarAt: 1 put: 6510; instVarAt: 2 put: (Duration seconds: -10800 nanoSeconds: 0); instVarAt: 3 put: 2458339; instVarAt: 4 put: 646584000; yourself)); add: (#passed->((Set new) add: #testSelectHandlers; add: #testResponsibility; yourself)); add: (#failures->((Set new))); add: (#errors->((Set new))); yourself)
]

{ #category : #tests }
CosmosCommandLineHandlerTest >> argumentsWith: aCollection [

	^ CommandLineArguments withArguments: aCollection
]

{ #category : #tests }
CosmosCommandLineHandlerTest >> testResponsibility [

	| arguments |

	arguments := self argumentsWith: #('cosmos').
	self assert: (CosmosCommandLineHandler isResponsibleFor: arguments)
]

{ #category : #tests }
CosmosCommandLineHandlerTest >> testSelectHandlers [

	| arguments handlers |

	arguments := self argumentsWith: #('cosmos').
	handlers := CommandLineHandler selectHandlersFor: arguments.
	self assert: handlers first = CosmosCommandLineHandler
]
