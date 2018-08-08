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

{ #category : #querying }
MetadataSystem >> describedObjectBy: data as: anAspect [

	^ self
		oneMetadataFilteredBy: [ :metadata | metadata aspect = anAspect and: [ metadata value = data ] ]
		ifFound: [ :foundMetadata | foundMetadata describedObject ]
		ifNone: [ ObjectNotFound
				signal: ('Object described <1p> as <2p> not found' expandMacrosWith: anAspect with: data) ]
]

{ #category : #initialization }
MetadataSystem >> initialize [

	super initialize.

	metadataSet := Set new
]

{ #category : #querying }
MetadataSystem >> metadataFor: anObject [

	^ metadataSet select: [ :metadata | metadata describedObject = anObject ]
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
