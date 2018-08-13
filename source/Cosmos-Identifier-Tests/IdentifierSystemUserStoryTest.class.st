Class {
	#name : #IdentifierSystemUserStoryTest,
	#superclass : #SystemBasedUserStoryTest,
	#category : #'Cosmos-Identifier-Tests'
}

{ #category : #initialization }
IdentifierSystemUserStoryTest >> setUpRequirements [

	super
		setUpRequirements;
		requireIdentifierSystem
]

{ #category : #accessing }
IdentifierSystemUserStoryTest >> startingIndentifier [

	^ 1
]

{ #category : #tests }
IdentifierSystemUserStoryTest >> testIdentifierRegistration [

	self identifierSystem registerIdentifierFor: 'name'.
	self
		assert: (self identifierSystem objectIdentifiedBy: self startingIndentifier)
		equals: 'name'
]
