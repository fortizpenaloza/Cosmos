Class {
	#name : #CaseBasedParser,
	#superclass : #Object,
	#instVars : [
		'cases'
	],
	#category : 'Cosmos-API-Core-Parsing'
}

{ #category : #'instance creation' }
CaseBasedParser class >> new [

	^ super new initialize
]

{ #category : #configuring }
CaseBasedParser >> initialize [

	super initialize.
	cases := Dictionary new.
]

{ #category : #parsing }
CaseBasedParser >> parse: aString [

	^ cases
		at: aString
		ifAbsent: [ ParsingFailed signal: ('"<1s>" is not a valid object' expandMacrosWith: aString) ]
]

{ #category : #configuring }
CaseBasedParser >> parsing: aCase to: anObject [

	cases at: aCase put: anObject 
]
