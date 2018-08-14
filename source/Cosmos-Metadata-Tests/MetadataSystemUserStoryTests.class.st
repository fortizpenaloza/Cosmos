Class {
	#name : #MetadataSystemUserStoryTests,
	#superclass : #SystemBasedUserStoryTest,
	#category : #'Cosmos-Metadata-Tests'
}

{ #category : #accessing }
MetadataSystemUserStoryTests >> identifier [

	^ UUID new
]

{ #category : #running }
MetadataSystemUserStoryTests >> setUpRequirements [

	super
		setUpRequirements;
		requireMetadataSystem
]

{ #category : #accessing }
MetadataSystemUserStoryTests >> temperature [

	^ DataStream named: 'Temperature'
]

{ #category : #tests }
MetadataSystemUserStoryTests >> testMetadataRegistration [

	| metadata |

	metadata := Metadata
		attaching: self identifier
		as: #identifier
		of: self temperature.

	self
		assert: (self metadataSystem metadataFor: self temperature) isEmpty.
	self metadataSystem register: metadata.
	self
		withTheOnlyOneIn: (self metadataSystem metadataFor: self temperature)
		do: [ :foundMetadata | self assert: foundMetadata equals: metadata ]
]

{ #category : #tests }
MetadataSystemUserStoryTests >> testMetadataRegistrationFailsWhenAlreadyExists [

	| metadata |

	metadata := Metadata
		attaching: self identifier
		as: #identifier
		of: self temperature.

	self metadataSystem register: metadata.
	self
		should: [ self metadataSystem register: metadata ]
		raise: ConflictingObjectFound
]

{ #category : #tests }
MetadataSystemUserStoryTests >> testQueryingAllMetadata [

	| identifier registrationTimestamp |
	
	self assert: (self metadataSystem metadataFor: self temperature) isEmpty.

	identifier := Metadata
		attaching: self identifier
		as: #identifier
		of: self temperature.

	registrationTimestamp := Metadata
		attaching: (December tenth , 2016) atMidnight
		as: #registration_timestamp
		of: self temperature.

	self metadataSystem register: identifier.
	self metadataSystem register: registrationTimestamp.
	self
		assert: (self metadataSystem metadataFor: self temperature)
		equals:
			{identifier.
			registrationTimestamp} asOrderedCollection
]

{ #category : #tests }
MetadataSystemUserStoryTests >> testQueryingDescribedObject [

	| identifier metadata |

	identifier := self identifier.

	metadata := Metadata
		attaching: identifier
		as: #identifier
		of: self temperature.

	self metadataSystem register: metadata.
	self
		assert:
			(self metadataSystem
				describedObjectBy: identifier
				as: #identifier
				ifNone: [ self fail ])
		equals: self temperature
]

{ #category : #tests }
MetadataSystemUserStoryTests >> testQueryingDescribedObjectFails [

	| metadata |

	metadata := Metadata attaching: 'celsius' as: #unit_singular of: self temperature.

	self metadataSystem register: metadata.

	self
		should: [ self metadataSystem
				describedObjectBy: 'meter'
				as: #unit_singular
				ifNone: [ Error signal ] ]
		raise: Error
]
