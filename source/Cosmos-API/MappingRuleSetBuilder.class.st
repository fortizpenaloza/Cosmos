Class {
	#name : #MappingRuleSetBuilder,
	#superclass : #Object,
	#instVars : [
		'decodingRules',
		'encodingRules'
	],
	#category : #'Cosmos-API-Model'
}

{ #category : #managing }
MappingRuleSetBuilder >> add: aReader asDecoderFor: aMimeType at: aKeyRepresentingScope [

	| decodingRule |

	decodingRule := MappingRule
		applying: aReader
		for: aMimeType
		at: aKeyRepresentingScope.

	decodingRules
		detect: [ :rule | rule mimeType = aMimeType and: [ rule scope = aKeyRepresentingScope ] ]
		ifFound:
			[ :foundRule | ConflictingObjectFound signal: 'Decoder for that MIME type already registered' ]
		ifNone: [ decodingRules add: decodingRule ]
]

{ #category : #managing }
MappingRuleSetBuilder >> add: aReader asDefaultDecoderFor: aMimeType at: aKeyRepresentingScope [

	| decodingRule |

	decodingRule := MappingRule
		applying: aReader
		for: aMimeType
		at: aKeyRepresentingScope.
	
	decodingRule beDefault.

	decodingRules
		detect: [ :rule | rule mimeType = aMimeType and: [ rule scope = aKeyRepresentingScope ] ]
		ifFound:
			[ :foundRule | ConflictingObjectFound signal: 'Decoder for that MIME type already registered' ]
		ifNone: [ decodingRules add: decodingRule ]
]

{ #category : #managing }
MappingRuleSetBuilder >> add: aWriter asDefaultEncoderFor: aMimeType at: aKeyRepresentingScope [

	| encodingRule |

	encodingRule := MappingRule
		applying: aWriter
		for: aMimeType
		at: aKeyRepresentingScope.
		
	encodingRule beDefault.

	encodingRules
		detect: [ :rule | rule mimeType = aMimeType and: [ rule scope = aKeyRepresentingScope ] ]
		ifFound:
			[ :foundRule | ConflictingObjectFound signal: 'Encoder for that MIME type already registered' ]
		ifNone: [ encodingRules add: encodingRule ]
]

{ #category : #managing }
MappingRuleSetBuilder >> add: aWriter asEncoderFor: aMimeType at: aKeyRepresentingScope [

	| mappingRule |

	mappingRule := MappingRule
		applying: aWriter
		for: aMimeType
		at: aKeyRepresentingScope.

	encodingRules
		detect: [ :rule | rule mimeType = aMimeType and: [ rule scope = aKeyRepresentingScope ] ]
		ifFound:
			[ :foundRule | ConflictingObjectFound signal: 'Encoder for that MIME type already registered' ]
		ifNone: [ encodingRules add: mappingRule ]
]

{ #category : #managing }
MappingRuleSetBuilder >> build [

	AssertionCheckerBuilder new
		checking: [ :asserter | 
			asserter
				enforce: [ (decodingRules groupedBy: #scope) values
						allSatisfy: [ :rules | (rules count: [ :rule | rule isDefault ]) = 1 ] ]
				because: 'You must provide a default decoder for each scope' ];
		buildAndCheck.

	AssertionCheckerBuilder new
		checking: [ :asserter | 
			asserter
				enforce: [ (encodingRules groupedBy: #scope) values
						allSatisfy: [ :rules | (rules count: [ :rule | rule isDefault ]) = 1 ] ]
				because: 'You must provide a default decoder for each scope' ];
		buildAndCheck.



	^ MappingRuleSet consistingOf: encodingRules and: decodingRules
]

{ #category : #initialization }
MappingRuleSetBuilder >> initialize [

	encodingRules := OrderedCollection new.
	decodingRules := OrderedCollection new
]
