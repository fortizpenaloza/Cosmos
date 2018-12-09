"
I'm a System that manages cosmos' objects metadata.
"
Class {
	#name : #MetadataSystem,
	#superclass : #SubsystemImplementation,
	#instVars : [
		'metadataSet'
	],
	#category : #'Cosmos-Metadata'
}

{ #category : #'private - preconditions' }
MetadataSystem >> assertIsNotAlreadyRegistered: metadata [

	AssertionChecker
		refuse: [ metadataSet includes: metadata ]
		because:
			('Metadata describing the <1p> of <2p> already exists in system'
				expandMacrosWith: metadata aspect
				with: metadata describedObject)
		raising: ConflictingObjectFound
]

{ #category : #querying }
MetadataSystem >> dataDescribing: anAspect of: anObject [

	^ self
		oneMetadataFilteredBy: [ :metadata | metadata aspect = anAspect and: [ metadata describedObject = anObject ] ]
		ifFound: [ :metadata | metadata data ]
		ifNone: [ ObjectNotFound signal: 'lala' ]
]

{ #category : #installing }
MetadataSystem >> dependencies [

	^ #()
]

{ #category : #querying }
MetadataSystem >> describedObjectBy: data as: anAspect ifNone: ifNoneBlock [

	^ self
		oneMetadataFilteredBy: [ :metadata | metadata aspect = anAspect and: [ metadata data = data ] ]
		ifFound: [ :foundMetadata | foundMetadata describedObject ]
		ifNone: ifNoneBlock
]

{ #category : #installing }
MetadataSystem >> implementedInterfaces [

	^ #(#MetadataSystemInterface)
]

{ #category : #initialization }
MetadataSystem >> initialize [

	super initialize.
	metadataSet := OrderedCollection new
]

{ #category : #querying }
MetadataSystem >> metadataFor: anObject [

	^ metadataSet select: [ :metadata | metadata describedObject = anObject ]
]

{ #category : #accessing }
MetadataSystem >> name [

	^ 'Metadata'
]

{ #category : #'private - querying' }
MetadataSystem >> oneMetadataFilteredBy: aFilter ifFound: ifFoundBlock ifNone: ifNoneBlock [

	^ metadataSet
		detect: aFilter
		ifFound: ifFoundBlock
		ifNone: ifNoneBlock
]

{ #category : #managing }
MetadataSystem >> register: metadata [

	self assertIsNotAlreadyRegistered: metadata.
	metadataSet add: metadata
]
