"
A CosmosCommandLineHandlerTest is a test class for testing the behavior of CosmosCommandLineHandler
"
Class {
	#name : #CosmosCommandLineHandlerTest,
	#superclass : #TestCase,
	#category : #'Cosmos-CommandLineHandler-Tests'
}

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
	self assert: (handlers includes: CosmosCommandLineHandler)
]
