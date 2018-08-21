Class {
	#name : #MappingRuleSet,
	#superclass : #Object,
	#instVars : [
		'decodingRules',
		'encodingRules'
	],
	#category : #'Cosmos-API-Model'
}

{ #category : #'instance creation' }
MappingRuleSet class >> consistingOf: encodingRules and: decodingRules [ 
	
	^ self new initializeConsistingOf: encodingRules and: decodingRules 
]

{ #category : #querying }
MappingRuleSet >> decoderFor: aMimeType at: aKeyRepresentingScope [

	| rule |

	^ self
		decodingRulesMatching: aMimeType
		at: aKeyRepresentingScope
		ifFound: [ :foundRules | 
			rule := foundRules
				detect: [ :mappingRule | mappingRule mimeType = aMimeType ]
				ifFound: [ :mappingRule | mappingRule ]
				ifNone: [ foundRules detect: #isDefault ].

			rule mapper ]
		ifNone: [ ObjectNotFound signal: 'Decoder not found for given MIME type' ]
]

{ #category : #'private - querying' }
MappingRuleSet >> decodingRulesMatching: aMimeType at: aKeyRepresentingScope ifFound: aFoundBlock ifNone: aNoneBlock [

	| filteredRules |

	filteredRules := decodingRules
		select: [ :decodingRule | 
			(decodingRule mimeType matches: aMimeType)
				and: [ decodingRule scope = aKeyRepresentingScope ] ].

	^ filteredRules isEmpty
		ifTrue: aNoneBlock
		ifFalse: [ aFoundBlock value: filteredRules ]
]

{ #category : #querying }
MappingRuleSet >> encoderFor: aMimeType at: aKeyRepresentingScope [

	| filteredRules rule |

	filteredRules := encodingRules
		select: [ :mappingRule | 
			(mappingRule mimeType matches: aMimeType)
				and: [ mappingRule scope = aKeyRepresentingScope ] ].

	filteredRules
		ifEmpty: [ ObjectNotFound signal: 'Encoder not found for given MIME type' ]
		ifNotEmpty: [ rule := filteredRules
				detect: [ :mappingRule | mappingRule mimeType = aMimeType ]
				ifFound: [ :mappingRule | mappingRule ]
				ifNone: [ filteredRules size = 1
						ifTrue: [ filteredRules anyOne ]
						ifFalse: [ filteredRules detect: #isDefault ] ].

			^ rule mapper ]
]

{ #category : #initialization }
MappingRuleSet >> initializeConsistingOf: aCollectionOfEncodingRules and: aCollectionOfDecodingRules [ 
	
	encodingRules := aCollectionOfEncodingRules.
	decodingRules := aCollectionOfDecodingRules
]
