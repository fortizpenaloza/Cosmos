Class {
	#name : #MappingRuleSetTest,
	#superclass : #TestCase,
	#category : #'Cosmos-API-Tests-Model'
}

{ #category : #history }
MappingRuleSetTest class >> lastStoredRun [
	^ ((Dictionary new) add: (#timeStamp->(DateAndTime basicNew instVarAt: 1 put: 6510; instVarAt: 2 put: (Duration seconds: -10800 nanoSeconds: 0); instVarAt: 3 put: 2458339; instVarAt: 4 put: 623551000; yourself)); add: (#passed->((Set new) add: #testBuilding; add: #testRegisteringEncoder; yourself)); add: (#failures->((Set new))); add: (#errors->((Set new))); yourself)
]

{ #category : #accessing }
MappingRuleSetTest >> applicationJsonVersion1dot0dot0 [

	^ ZnMimeType fromString: 'application/json; version=1.0.0'
]

{ #category : #accessing }
MappingRuleSetTest >> applicationJsonVersion1dot0dot1 [

	^ ZnMimeType fromString: 'application/json; version=1.0.1'
]

{ #category : #tests }
MappingRuleSetTest >> testQueryingDecoderForAnyMimeTypeGivesDefault [

	| mappingRuleSetBuilder mappingRuleSet decoder |

	mappingRuleSetBuilder := MappingRuleSetBuilder new.

	mappingRuleSetBuilder
		add: self triggerJsonDecoderVersion1dot0dot0
		asDecoderFor: self applicationJsonVersion1dot0dot0
		within: #triggers.

	mappingRuleSetBuilder
		add: self triggerJsonDecoderVersion1dot0dot1
		asDefaultDecoderFor: self applicationJsonVersion1dot0dot1
		within: #triggers.

	mappingRuleSet := mappingRuleSetBuilder build.

	decoder := mappingRuleSet decoderFor: ZnMimeType any within: #triggers.
	self assert: decoder equals: self triggerJsonDecoderVersion1dot0dot1
]

{ #category : #tests }
MappingRuleSetTest >> testQueryingDecoderNotRegisteredMimeTypeGivesObjectNotFound [

	| mappingRuleSetBuilder mappingRuleSet |

	mappingRuleSetBuilder := MappingRuleSetBuilder new.

	mappingRuleSetBuilder
		add: self triggerTextDecoder
		asDefaultDecoderFor: self textPlain
		within: #triggers.

	mappingRuleSet := mappingRuleSetBuilder build.

	self
		should: [ mappingRuleSet decoderFor: self applicationJsonVersion1dot0dot0 within: #triggers ]
		raise: ObjectNotFound
]

{ #category : #tests }
MappingRuleSetTest >> testQueryingDecoderSpecificVersion [

	| mappingRuleSetBuilder mappingRuleSet decoder |

	mappingRuleSetBuilder := MappingRuleSetBuilder new.

	mappingRuleSetBuilder
		add: self triggerJsonDecoderVersion1dot0dot0
		asDecoderFor: self applicationJsonVersion1dot0dot0
		within: #triggers.

	mappingRuleSetBuilder
		add: self triggerJsonDecoderVersion1dot0dot1
		asDefaultDecoderFor: self applicationJsonVersion1dot0dot1
		within: #triggers.
		
	mappingRuleSet :=	mappingRuleSetBuilder build.

	decoder := mappingRuleSet
		decoderFor: self applicationJsonVersion1dot0dot0
		within: #triggers.
	self assert: decoder equals: self triggerJsonDecoderVersion1dot0dot0
]

{ #category : #tests }
MappingRuleSetTest >> testQueryingEncoderForAnyMimeTypeGivesDefault [

	| mappingRuleSetBuilder mappingRuleSet encoder |

	mappingRuleSetBuilder := MappingRuleSetBuilder new.

	mappingRuleSetBuilder
		add: self triggerJsonEncoderVersion1dot0dot0
		asEncoderFor: self applicationJsonVersion1dot0dot0
		within: #triggers.

	mappingRuleSetBuilder
		add: self triggerJsonEncoderVersion1dot0dot1
		asDefaultEncoderFor: self applicationJsonVersion1dot0dot1
		within: #triggers.

	mappingRuleSet := mappingRuleSetBuilder build.

	encoder := mappingRuleSet encoderFor: ZnMimeType any within: #triggers.
	self assert: encoder equals: self triggerJsonEncoderVersion1dot0dot1
]

{ #category : #accessing }
MappingRuleSetTest >> textPlain [

	^ ZnMimeType fromString: 'text/plain;charset=utf-8'
]

{ #category : #accessing }
MappingRuleSetTest >> triggerJsonDecoderVersion1dot0dot0 [

	^ #triggerJsonDecoderVersion1dot0dot0
]

{ #category : #accessing }
MappingRuleSetTest >> triggerJsonDecoderVersion1dot0dot1 [

	^ #triggerJsonDecoderVersion1dot0dot1
]

{ #category : #accessing }
MappingRuleSetTest >> triggerJsonEncoderVersion1dot0dot0 [
	
	^ #triggerJsonEncoderVersion1dot0dot0
]

{ #category : #accessing }
MappingRuleSetTest >> triggerJsonEncoderVersion1dot0dot1 [
	
	^ #triggerJsonEncoderVersion1dot0dot1
]

{ #category : #accessing }
MappingRuleSetTest >> triggerTextDecoder [

	^ #triggerTextDecoder
]
