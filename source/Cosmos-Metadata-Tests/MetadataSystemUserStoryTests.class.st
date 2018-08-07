Class {
	#name : #MetadataSystemUserStoryTests,
	#superclass : #SystemBasedUserStoryTest,
	#category : #'Cosmos-Metadata-Tests'
}

{ #category : #accessing }
MetadataSystemUserStoryTests >> livingTemperature [

	^ DataStream named: 'Living temperature' createdOn: September sixth, 1979
]

{ #category : #running }
MetadataSystemUserStoryTests >> setUpRequirements [

	super
		setUpRequirements;
		requireMetadataSystem
]

{ #category : #tests }
MetadataSystemUserStoryTests >> temperature [

	^ DataStream named: 'Temperature' createdOn: September sixth, 1979
]

{ #category : #tests }
MetadataSystemUserStoryTests >> testMetadataRegistration [

	| metadata |

	metadata := Metadata
		about: self temperature
		where: #identifier
		is: UUID new.

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
		about: self temperature
		where: #identifier
		is: UUID new.

	self metadataSystem register: metadata.
	self
		should: [ self metadataSystem register: metadata ]
		raise: ConflictingObjectFound
]

{ #category : #tests }
MetadataSystemUserStoryTests >> testQueryingAllMetadata [

	| identifier registrationTimestamp |

	identifier := Metadata
		about: self temperature
		where: #identifier
		is: UUID new.

	registrationTimestamp := Metadata
		about: self temperature
		where: #registration_timestamp
		is: (December tenth , 2016) atMidnight.

	self metadataSystem register: identifier.
	self metadataSystem register: registrationTimestamp.
	self
		assert: (self metadataSystem metadataFor: self temperature)
		equals:
			{identifier.
			registrationTimestamp} asSet
]

{ #category : #tests }
MetadataSystemUserStoryTests >> testQueryingDescribedObject [

	| identifier metadata |

	identifier := UUID new.
	metadata := Metadata
		about: self temperature
		where: #identifier
		is: identifier.

	self metadataSystem register: metadata.
	self
		assert: (self metadataSystem objectWhere: #identifier is: identifier)
		equals: self temperature
]

{ #category : #tests }
MetadataSystemUserStoryTests >> testQueryingDescribedObjectFailsWhenInformationAndAspectDuplicated [

	| temperatureIdentifier livingTemperatureIdentifier identifier |

	identifier := UUID new.

	temperatureIdentifier := Metadata
		about: self temperature
		where: #identifier
		is: identifier.

	livingTemperatureIdentifier := Metadata
		about: self livingTemperature
		where: #identifier
		is: identifier.

	self metadataSystem register: temperatureIdentifier.
	self metadataSystem register: livingTemperatureIdentifier.
	self
		assert: (self metadataSystem objectWhere: #identifier is: identifier)
		equals: self temperature
]

{ #category : #tests }
MetadataSystemUserStoryTests >> testQueryingSingleMetadata [

	| identifier metadata |

	identifier := UUID new.
	metadata := Metadata
		about: self temperature
		where: #identifier
		is: identifier.

	self metadataSystem register: metadata.
	self
		assert:
			(self metadataSystem
				metadataDescribing: #identifier
				of: self temperature)
		equals: metadata
]
