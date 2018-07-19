Class {
	#name : #MetadataSystemUserStoryTests,
	#superclass : #SystemBasedUserStoryTest,
	#category : #'Cosmos-Metadata-Tests'
}

{ #category : #running }
MetadataSystemUserStoryTests >> setUpRequirements [

	super
		setUpRequirements;
		requireMetadataSystem
]

{ #category : #tests }
MetadataSystemUserStoryTests >> testMetadataRegistration [

	| identifier |

	identifier := UUID new.

	self
		should: [ self metadataSystem metadataFor: 1 of: #identifier ]
		raise: ObjectNotFound.
	self metadataSystem register: identifier of: #identifier for: 1.
	self
		assert: (self metadataSystem metadataFor: 1 of: #identifier)
		equals: identifier
]

{ #category : #tests }
MetadataSystemUserStoryTests >> testMetadataRegistrationFailsWhenAlreadyExists [

	| identifier |

	identifier := UUID new.

	self metadataSystem register: identifier of: #identifier for: 1.
	self
		should: [ self metadataSystem register: identifier of: #identifier for: 1 ]
		raise: ConflictingObjectFound
]

{ #category : #tests }
MetadataSystemUserStoryTests >> testQueryingAllMetadata [

	| identifier registrationTimestamp |

	identifier := UUID new.
	registrationTimestamp := (December tenth , 2016) atMidnight.

	self metadataSystem register: identifier of: #identifier for: 1.
	self metadataSystem register: registrationTimestamp of: #registration_timestamp for: 1.
	self
		assert: (self metadataSystem metadataFor: 1)
		equals:
			{(#registration_timestamp -> registrationTimestamp).
			(#identifier -> identifier)}
]

{ #category : #tests }
MetadataSystemUserStoryTests >> testQueryingSingleMetadata [

	| identifier |

	identifier := UUID new.

	self metadataSystem register: identifier of: #identifier for: 1.
	self assert: (self metadataSystem metadataFor: 1 of: #identifier) equals: identifier
]
