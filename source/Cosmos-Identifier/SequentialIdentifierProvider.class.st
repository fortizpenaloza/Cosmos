"
I'm an IdentifierProvider. 

I provide a polymorphic alternative to UUIDProvider>>#next answering with an identifier, sequentially and in a circular way, from a predetermined sequence.

"
Class {
	#name : #SequentialIdentifierProvider,
	#superclass : #IdentifierProvider,
	#instVars : [
		'sequence'
	],
	#category : #'Cosmos-Identifier'
}

{ #category : #'private - preconditions' }
SequentialIdentifierProvider class >> assertIsNotEmpty: aSequence [

	AssertionCheckerBuilder new
		raising: InstanceCreationFailed;
		checking: [ :asserter | 
			asserter
				refuse: [ aSequence isEmpty ]
				because: 'Sequence shouldn''t be empty' ];
		buildAndCheck
]

{ #category : #'instance creation' }
SequentialIdentifierProvider class >> providing: aSequence [

	self assertIsNotEmpty: aSequence.

	^ self new initiliazeProviding: aSequence
]

{ #category : #initialization }
SequentialIdentifierProvider >> initiliazeProviding: aSequence [ 

	sequence := CircularIterator cyclingOver: aSequence 
]

{ #category : #providing }
SequentialIdentifierProvider >> next [

	| identifier |

	identifier := sequence current.
	sequence next.
	^ identifier
]
