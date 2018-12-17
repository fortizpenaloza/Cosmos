Class {
	#name : #TimestampingSystem,
	#superclass : #SubsystemImplementation,
	#category : #'Cosmos-Timestamping'
}

{ #category : #installing }
TimestampingSystem >> dependencies [

	^ #(#MetadataSystemInterface #TimeSystemInterface)
]

{ #category : #installing }
TimestampingSystem >> implementedInterfaces [

	^ #(#TimestampingSystemInterface)
]

{ #category : #querying }
TimestampingSystem >> lastModificationOf: anObject [

	^ self metadataSystem dataDescribing: #update_timestamp of: anObject
]

{ #category : #'private - systems' }
TimestampingSystem >> metadataSystem [

	^ self >> #MetadataSystemInterface
]

{ #category : #accessing }
TimestampingSystem >> name [

	^ 'Timestamping'
]

{ #category : #managing }
TimestampingSystem >> registerModificationFor: anObject [

	self metadataSystem
		register:
			(Metadata
				attaching: self timeSystem dateTime
				as: #update_timestamp
				of: anObject)
]

{ #category : #'private - systems' }
TimestampingSystem >> timeSystem [

	^ self >> #TimeSystemInterface
]
