Class {
	#name : #MappingRegistry,
	#superclass : #Object,
	#instVars : [
		'encoders',
		'decoders'
	],
	#category : #'Cosmos-API-Model'
}

{ #category : #managing }
MappingRegistry >> add: aReader asDecoderFor: aMimeType at: aKeyRepresentingDomainObject [

	| mappingRule |

	mappingRule := MappingRule applying: aReader for: aMimeType.

	decoders
		at: aKeyRepresentingDomainObject
		ifPresent: [ :rules | 
			rules
				detect: [ :rule | rule mimeType = mappingRule mimeType ]
				ifFound: [ :blhe | ConflictingObjectFound signal: 'Decoder for that MIME type already registered' ]
				ifNone: [ rules add: mappingRule ] ]
		ifAbsentPut: (OrderedCollection with: mappingRule)
]

{ #category : #managing }
MappingRegistry >> add: aReader asDefaultDecoderFor: aMimeType at: aKeyRepresentingDomainObject [ 

	| mappingRule |

	mappingRule := MappingRule applying: aReader for: aMimeType.

	decoders
		at: aKeyRepresentingDomainObject
		ifPresent: [ :rules | 
			rules
				detect: [ :rule | rule mimeType = mappingRule mimeType ]
				ifFound: [ :blhe | ConflictingObjectFound signal: 'Decoder for that MIME type already registered' ]
				ifNone: [ rules add: mappingRule ] ]
		ifAbsentPut: (OrderedCollection with: mappingRule)
]

{ #category : #managing }
MappingRegistry >> add: aWriter asEncoderFor: aMimeType at: aKeyRepresentingDomainObject [

	| mappingRule |

	mappingRule := MappingRule applying: aWriter for: aMimeType.

	encoders
		at: aKeyRepresentingDomainObject
		ifPresent: [ :mimeType | 
			ConflictingObjectFound
				signal: 'Encoder for that MIME type already registered' ]
		ifAbsentPut: (OrderedCollection with: mappingRule)
]

{ #category : #querying }
MappingRegistry >> decoderFor: aMimeType at: aKeyRepresentingDomainObject [

	^ decoders
		at: aKeyRepresentingDomainObject
		ifPresent: [ :mappingRules | 
			| matchingMappingRules |

			matchingMappingRules := mappingRules
				select: [ :mappingRule | mappingRule mimeType matches: aMimeType ].

			matchingMappingRules
				detect: [ :mappingRule | mappingRule mimeType = aMimeType ]
				ifFound: [ :mappingRule | mappingRule mapper ]
				ifNone: [ matchingMappingRules size = 1
						ifTrue: [ matchingMappingRules anyOne mapper ]
						ifFalse: [ self halt ] ] ]
		ifAbsent: [ ObjectNotFound signal: 'Decoder not found for given MIME type' ]
]

{ #category : #querying }
MappingRegistry >> encoderFor: aMimeType at: aKeyRepresentingDomainObject [

	^ encoders
		at: aKeyRepresentingDomainObject
		ifPresent: [ :mappings | 
			mappings
				detect: [ :mapping | mapping mimeType = aMimeType ]
				ifFound: [ :mappingRule | mappingRule mapper ]
				ifNone: [ self halt ] ]
		ifAbsent: [ ObjectNotFound signal: 'Encoder not found for given MIME type' ]
]

{ #category : #initialization }
MappingRegistry >> initialize [

	encoders := Dictionary new.
	decoders := Dictionary new
]
