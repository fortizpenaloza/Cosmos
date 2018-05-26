Class {
	#name : #PluggableMockObject,
	#superclass : #ProtoObject,
	#instVars : [
		'knowResponses'
	],
	#category : 'Cosmos-ActionEvaluator-Tests'
}

{ #category : #'instance creation' }
PluggableMockObject class >> new [

	^ super new initialize
]

{ #category : #'reflective operations' }
PluggableMockObject >> doesNotUnderstand: aMessage [

	^ knowResponses
		at: aMessage selector
		ifPresent: [ :implementation | implementation value ]
		ifAbsent: [ super doesNotUnderstand: aMessage ]
]

{ #category : #configuring }
PluggableMockObject >> initialize [

	knowResponses := Dictionary new
]

{ #category : #configuring }
PluggableMockObject >> respondTo: aMessage with: aBlock [

	knowResponses at: aMessage put: aBlock
]
