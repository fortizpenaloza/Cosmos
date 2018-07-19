Class {
	#name : #MetadataSystem,
	#superclass : #System,
	#instVars : [
		'metadata'
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

	metadata := Dictionary new.
]

{ #category : #querying }
MetadataSystem >> metadataFor: anObject [

	^ self
		metadataFor: anObject
		ifFound: [ :foundMetadata | foundMetadata associations ]
		ifNone: [ #() ]
]

{ #category : #'private-querying' }
MetadataSystem >> metadataFor: anObject ifFound: ifFoundBlock ifNone: ifNoneBlock [

	^ metadata at: anObject ifPresent: ifFoundBlock ifAbsent: ifNoneBlock
]

{ #category : #querying }
MetadataSystem >> metadataFor: anObject of: aType [

	^ self
		metadataFor: anObject
		ifFound: [ :foundMetadata | foundMetadata at: aType ]
		ifNone: [ ObjectNotFound
				signal: ('Metadata of type <1p> not found for <2p>' expandMacrosWith: aType with: anObject) ]
]

{ #category : #managing }
MetadataSystem >> register: data of: aType for: anObject [

	self
		metadataFor: anObject
		ifFound: [ :foundMetadata | 
			foundMetadata
				at: aType
				ifPresent: [ :foundMetadataForType | 
					ConflictingObjectFound
						signal: ('Metadata of type <1p> already defined for <2p>' expandMacrosWith: aType with: anObject) ]
				ifAbsentPut: [ data ] ]
		ifNone: [ metadata
				at: anObject
				put:
					(Dictionary new
						add: aType -> data;
						yourself) ]
]

{ #category : #'dependency resolution' }
MetadataSystem >> resolveDependecies [

	"do nothing"
]
