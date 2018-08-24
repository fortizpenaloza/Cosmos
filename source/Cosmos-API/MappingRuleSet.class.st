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
MappingRuleSet >> decoderFor: aMediaType within: aScope [

	| rule |

	^ self
		decodingRulesMatching: aMediaType
		within: aScope
		ifFound: [ :foundRules | 
			rule := foundRules
				detect: [ :mappingRule | mappingRule mediaType = aMediaType ]
				ifFound: [ :mappingRule | mappingRule ]
				ifNone: [ foundRules detect: #isDefault ].

			rule mapper ]
		ifNone: [ ObjectNotFound signal: 'Decoder not found for given MIME type' ]
]

{ #category : #'private - querying' }
MappingRuleSet >> decodingRulesMatching: aMediaType within: aScope ifFound: aFoundBlock ifNone: aNoneBlock [

	^ self
		with: decodingRules
		matching: aMediaType
		within: aScope
		ifFound: aFoundBlock
		ifNone: aNoneBlock
]

{ #category : #querying }
MappingRuleSet >> encoderFor: aMediaType within: aScope [

	| rule |

	^ self
		encodingRulesMatching: aMediaType
		within: aScope
		ifFound: [ :foundRules | 
			rule := foundRules
				detect: [ :mappingRule | mappingRule mediaType = aMediaType ]
				ifFound: [ :mappingRule | mappingRule ]
				ifNone: [ foundRules detect: #isDefault ].

			rule mapper ]
		ifNone: [ ObjectNotFound signal: 'Encoder not found for given MIME type' ]
]

{ #category : #'private - querying' }
MappingRuleSet >> encodingRulesMatching: aMediaType within: aScope ifFound: aFoundBlock ifNone: aNoneBlock [

	^ self
		with: encodingRules 
		matching: aMediaType
		within: aScope
		ifFound: aFoundBlock
		ifNone: aNoneBlock
]

{ #category : #initialization }
MappingRuleSet >> initializeConsistingOf: aCollectionOfEncodingRules and: aCollectionOfDecodingRules [ 
	
	encodingRules := aCollectionOfEncodingRules.
	decodingRules := aCollectionOfDecodingRules
]

{ #category : #'private - querying' }
MappingRuleSet >> with: aMappingRuleSet matching: aMediaType within: aScope ifFound: aFoundBlock ifNone: aNoneBlock [

	| filteredRules |

	filteredRules := aMappingRuleSet
		select: [ :mappingRule | 
			(mappingRule mediaType matches: aMediaType)
				and: [ mappingRule scope = aScope ] ].

	^ filteredRules isEmpty
		ifTrue: aNoneBlock
		ifFalse: [ aFoundBlock value: filteredRules ]
]
