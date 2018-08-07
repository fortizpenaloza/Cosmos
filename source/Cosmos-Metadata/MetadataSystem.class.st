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

{ #category : #initialization }
MetadataSystem >> initialize [

	super initialize.

	metadataSet := Set new
]

{ #category : #querying }
MetadataSystem >> metadataDescribing: anAspect of: anObject [

	^ self
		oneMetadataFilteredBy: [ :metadata | metadata aspect = anAspect and: [ metadata describedObject = anObject ] ]
		ifFound: [ :foundMetadata | foundMetadata ]
		ifNone: [ ObjectNotFound
				signal: ('Metadata describing <1p> of <2p> not found' expandMacrosWith: anAspect with: anObject) ]
]

{ #category : #querying }
MetadataSystem >> metadataFor: anObject [

	^ metadataSet select: [ :metadata | metadata describedObject = anObject ]
]

{ #category : #querying }
MetadataSystem >> objectWhere: anAspect is: aValue [

	^ self
		oneMetadataFilteredBy: [ :metadata | metadata aspect = anAspect and: [ metadata value = aValue ] ]
		ifFound: [ :foundMetadata | foundMetadata describedObject ]
		ifNone: [ ObjectNotFound
				signal: ('Object described <1p> as <2p> not found' expandMacrosWith: anAspect with: aValue) ]
]

{ #category : #'private-querying' }
MetadataSystem >> oneMetadataFilteredBy: aFilter ifFound: ifFoundBlock ifNone: ifNoneBlock [

	^ metadataSet
		detect: aFilter
		ifFound: ifFoundBlock
		ifNone: ifNoneBlock
]

{ #category : #managing }
MetadataSystem >> register: metadata [

	(metadataSet includes: metadata)
		ifTrue: [ ConflictingObjectFound
				signal:
					('Metadata describing the <1p> of <2p> already exists in system'
						expandMacrosWith: metadata aspect
						with: metadata describedObject) ].

	metadataSet add: metadata
]

{ #category : #'dependency resolution' }
MetadataSystem >> resolveDependecies [

	"do nothing"
]
