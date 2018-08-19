Class {
	#name : #IdentifierSystem,
	#superclass : #System,
	#instVars : [
		'identifierProvider',
		'metadataSystem'
	],
	#category : #'Cosmos-Identifier'
}

{ #category : #'system specification' }
IdentifierSystem class >> implementedInterface [

	^ SystemInterface >> #IdentifierSystemInterface
]

{ #category : #'instance creation' }
IdentifierSystem class >> using: anIdentifierProvider [

	^ self new initializeUsing: anIdentifierProvider 
]

{ #category : #querying }
IdentifierSystem >> identifierOf: anObject [

	| a |

	a := (metadataSystem metadataFor: anObject)
		detect: [ :metadata | metadata aspect = #identifier ]
		ifNone: [ ObjectNotFound signal: ('Identifier for <1p> not found' expandMacrosWith: anObject) ].

	^ a value
]

{ #category : #initialization }
IdentifierSystem >> initializeUsing: anIdentifierProvider [

	super initialize.
	identifierProvider := anIdentifierProvider.

	metadataSystem := self unresolvedSystemDependencyTo: #MetadataSystemInterface
]

{ #category : #'private - providing identifier' }
IdentifierSystem >> next [
	
	^identifierProvider next 
]

{ #category : #querying }
IdentifierSystem >> objectIdentifiedBy: anIdentifier ifNone: ifNoneBlock [

	^ metadataSystem
		describedObjectBy: anIdentifier
		as: #identifier
		ifNone: ifNoneBlock
]

{ #category : #managing }
IdentifierSystem >> registerIdentifierFor: anObject [
	
	metadataSystem
		register:
			(Metadata
				attaching: self next
				as: #identifier
				of: anObject)
]

{ #category : #initialization }
IdentifierSystem >> resolveDependecies [

	metadataSystem := self resolveSystemDependencyTo: #MetadataSystemInterface
]
