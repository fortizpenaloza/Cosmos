Class {
	#name : #IdentifierSystemUserStoryTest,
	#superclass : #SystemBasedUserStoryTest,
	#category : #'Cosmos-Identifier-Tests'
}

{ #category : #initialization }
IdentifierSystemUserStoryTest >> setUpRequirements [

	self
		registerSubsystem: MetadataSystem new;
		registerSubsystem: (IdentifierSystem using: self identifierProvider)
]

{ #category : #tests }
IdentifierSystemUserStoryTest >> testIdentifierRegistration [

	self identifierSystem registerIdentifierFor: #object.
	self
		assert:
			(self identifierSystem
				objectIdentifiedBy: self currentIdentifier 
				ifNone: [ self fail ])
		equals: #object
]

{ #category : #tests }
IdentifierSystemUserStoryTest >> testQueryingIdentifier [

	self identifierSystem registerIdentifierFor: #object.
	self assert: (self identifierSystem identifierOf: #object) equals: self currentIdentifier
]

{ #category : #tests }
IdentifierSystemUserStoryTest >> testQueryingIdentifierFailsIfNotRegistered [

	self
		should: [ self identifierSystem identifierOf: #notRegisteredObject ]
		raise: ObjectNotFound
		withMessageText: 'Identifier for #notRegisteredObject not found'
]

{ #category : #tests }
IdentifierSystemUserStoryTest >> testQueryingObjectByIdentifierFailsIfNotRegistered [

	self assert: (self identifierSystem objectIdentifiedBy: self currentIdentifier ifNone: [ true ])
]
