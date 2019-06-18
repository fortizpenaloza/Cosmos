Class {
	#name : #MetadataSystemUserStoryTests,
	#superclass : #SystemBasedUserStoryTest,
	#category : #'Cosmos-Metadata-Tests'
}

{ #category : #accessing }
MetadataSystemUserStoryTests >> describedObject [

	^ #describedObject 
]

{ #category : #accessing }
MetadataSystemUserStoryTests >> identifier [

	^ UUID fromString: 'ab203809-4537-0d00-96a8-67bd07fa2cfc'
]

{ #category : #running }
MetadataSystemUserStoryTests >> setUpRequirements [

	self registerSubsystem: MetadataSystem new
]

{ #category : #tests }
MetadataSystemUserStoryTests >> testAccessing [ 
	
	self assert: self metadataSystem name equals: 'Metadata'
	
]

{ #category : #tests }
MetadataSystemUserStoryTests >> testMetadataRegistration [

	| metadata |

	metadata := Metadata
		attaching: self identifier
		as: #identifier
		of: self describedObject.

	self
		assert: (self metadataSystem metadataFor: self describedObject) isEmpty.
	self metadataSystem register: metadata.
	self
		withTheOnlyOneIn: (self metadataSystem metadataFor: self describedObject)
		do: [ :foundMetadata | self assert: foundMetadata equals: metadata ]
]

{ #category : #tests }
MetadataSystemUserStoryTests >> testMetadataRegistrationFailsWhenAlreadyExists [

	| metadata |

	metadata := Metadata
		attaching: self identifier
		as: #identifier
		of: self describedObject.

	self metadataSystem register: metadata.
	self
		should: [ self metadataSystem register: metadata ]
		raise: ConflictingObjectFound
]

{ #category : #tests }
MetadataSystemUserStoryTests >> testQueryingAllMetadata [

	| identifier registrationTimestamp |

	self
		assert: (self metadataSystem metadataFor: self describedObject) isEmpty.

	identifier := Metadata
		attaching: self identifier
		as: #identifier
		of: self describedObject.

	registrationTimestamp := Metadata
		attaching: (December tenth , 2016) atMidnight
		as: #registration_timestamp
		of: self describedObject.

	self metadataSystem register: identifier.
	self metadataSystem register: registrationTimestamp.
	self
		assert: (self metadataSystem metadataFor: self describedObject)
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
		of: self describedObject.

	self metadataSystem register: metadata.
	self
		assert:
			(self metadataSystem
				describedObjectBy: identifier
				as: #identifier
				ifNone: [ self fail ])
		equals: self describedObject
]

{ #category : #tests }
MetadataSystemUserStoryTests >> testQueryingDescribedObjectFails [

	| metadata |

	metadata := Metadata
		attaching: 'celsius'
		as: #unit_singular
		of: self describedObject.

	self metadataSystem register: metadata.

	self
		should: [ self metadataSystem
				describedObjectBy: 'meter'
				as: #unit_singular
				ifNone: [ Error signal ] ]
		raise: Error
]

{ #category : #tests }
MetadataSystemUserStoryTests >> testQueryingSpecificMetadata [

	| identifier |

	self
		assert: (self metadataSystem metadataFor: self describedObject) isEmpty.

	identifier := Metadata
		attaching: self identifier
		as: #identifier
		of: self describedObject.

	self metadataSystem register: identifier.
		
	self
		assert: (self metadataSystem dataDescribing: #identifier of: self describedObject)
		equals: self identifier
]

{ #category : #tests }
MetadataSystemUserStoryTests >> testQueryingSpecificMetadataFailsIfNotFound [

	self
		assert: (self metadataSystem metadataFor: self describedObject) isEmpty.

	self
		should: [ self metadataSystem
				dataDescribing: #identifier
				of: self describedObject ]
		raise: ObjectNotFound 
		withMessageText: 'Data describing #identifier aspect of #describedObject not found'
]
