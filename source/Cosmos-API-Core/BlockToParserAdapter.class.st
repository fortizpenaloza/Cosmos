Class {
	#name : #BlockToParserAdapter,
	#superclass : #Object,
	#instVars : [
		'block'
	],
	#category : 'Cosmos-API-Core-Parsing'
}

{ #category : #'instance creation' }
BlockToParserAdapter class >> onParsingEvaluate: aBlock [

	^ self new initializeOnParsingEvaluate: aBlock 
]

{ #category : #'class initialization' }
BlockToParserAdapter >> initializeOnParsingEvaluate: aBlock [

	block := aBlock
]

{ #category : #parsing }
BlockToParserAdapter >> parse: aString [ 
	
	^ block value: aString 
]
