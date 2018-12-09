Class {
	#name : #IdentifierSystem,
	#superclass : #SubsystemImplementation,
	#instVars : [
		'identifierProvider'
	],
	#category : #'Cosmos-Identifier'
}

{ #category : #'instance creation' }
IdentifierSystem class >> using: anIdentifierProvider [

	^ self new initializeUsing: anIdentifierProvider 
]

{ #category : #installing }
IdentifierSystem >> dependencies [

	^ #(#MetadataSystemInterface)
]

{ #category : #'private - accessing' }
IdentifierSystem >> identifierAspect [

	^ #identifier
]

{ #category : #querying }
IdentifierSystem >> identifierOf: anObject [

	| identifierMetadata |

	identifierMetadata := (self metadataSystem metadataFor: anObject)
		detect: [ :metadata | metadata aspect = self identifierAspect ]
		ifNone: [ ObjectNotFound signal: ('Identifier for <1p> not found' expandMacrosWith: anObject) ].

	^ identifierMetadata data
]

{ #category : #installing }
IdentifierSystem >> implementedInterfaces [

	^ #(#IdentifierSystemInterface)
]

{ #category : #initialization }
IdentifierSystem >> initializeUsing: anIdentifierProvider [

	self initialize.
	identifierProvider := anIdentifierProvider
]

{ #category : #'private - systems' }
IdentifierSystem >> metadataSystem [

	^ self >> #MetadataSystemInterface
]

{ #category : #accessing }
IdentifierSystem >> name [

	^ 'Identifier'
]

{ #category : #querying }
IdentifierSystem >> objectIdentifiedBy: anIdentifier ifNone: ifNoneBlock [

	^ self metadataSystem
		describedObjectBy: anIdentifier
		as: self identifierAspect 
		ifNone: ifNoneBlock
]

{ #category : #managing }
IdentifierSystem >> registerIdentifierFor: anObject [

	self metadataSystem
		register:
			(Metadata
				attaching: identifierProvider next
				as: self identifierAspect
				of: anObject)
]
