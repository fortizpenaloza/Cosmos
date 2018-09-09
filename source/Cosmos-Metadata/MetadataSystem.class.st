"
I'm a System that manages cosmos' objects metadata.
"
Class {
	#name : #MetadataSystem,
	#superclass : #System,
	#instVars : [
		'metadataSet'
	],
	#category : #'Cosmos-Metadata'
}

{ #category : #'system specification' }
MetadataSystem class >> implementedInterface [
	
	^ SystemInterface >> #MetadataSystemInterface
]

{ #category : #'private - preconditions' }
MetadataSystem >> assertIsNotAlreadyRegistered: metadata [

	AssertionCheckerBuilder new
		raising: ConflictingObjectFound;
		checking: [ :asserter | 
			asserter
				refuse: [ metadataSet includes: metadata ]
				because:
					('Metadata describing the <1p> of <2p> already exists in system'
						expandMacrosWith: metadata aspect
						with: metadata describedObject) ];
		buildAndCheck
]

{ #category : #querying }
MetadataSystem >> describedObjectBy: data as: anAspect ifNone: ifNoneBlock [

	^ self
		oneMetadataFilteredBy: [ :metadata | metadata aspect = anAspect and: [ metadata data = data ] ]
		ifFound: [ :foundMetadata | foundMetadata describedObject ]
		ifNone: ifNoneBlock
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

{ #category : #'dependency resolution' }
MetadataSystem >> resolveDependecies [

	"do nothing"
]
