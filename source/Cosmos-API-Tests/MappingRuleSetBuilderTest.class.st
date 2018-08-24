Class {
	#name : #MappingRuleSetBuilderTest,
	#superclass : #TestCase,
	#category : #'Cosmos-API-Tests-Model'
}

{ #category : #accessing }
MappingRuleSetBuilderTest >> applicationJsonVersion1dot0dot0 [

	^ ZnMimeType fromString: 'application/json;version=1.0.0'
]

{ #category : #accessing }
MappingRuleSetBuilderTest >> applicationJsonVersion1dot0dot1 [

	^ ZnMimeType fromString: 'application/json; version=1.0.1'
]

{ #category : #tests }
MappingRuleSetBuilderTest >> testAddingDecoderForAlreadyAddedMimeTypeFails [

	| mappingRegistry |

	mappingRegistry := MappingRuleSetBuilder new.

	mappingRegistry
		add: self triggerJsonDecoderVersion1dot0dot0
		asEncoderFor: ZnMimeType textPlain
		within: #triggers.

	self
		should: [ mappingRegistry
				add: self triggerJsonDecoderVersion1dot0dot0
				asEncoderFor: ZnMimeType textPlain
				within: #triggers ]
		raise: ConflictingObjectFound
]

{ #category : #tests }
MappingRuleSetBuilderTest >> testAddingEncoderForAlreadyAddedMimeTypeFails [

	| mappingRegistry |

	mappingRegistry := MappingRuleSetBuilder new.

	mappingRegistry
		add: self triggerJsonEncoderVersion1dot0dot0
		asEncoderFor: ZnMimeType textPlain
		within: #triggers.

	self
		should: [ mappingRegistry
				add: self triggerJsonEncoderVersion1dot0dot0
				asEncoderFor: ZnMimeType textPlain
				within: #triggers ]
		raise: ConflictingObjectFound
]

{ #category : #tests }
MappingRuleSetBuilderTest >> testBuilding [

	| mappingRuleSetBuilder mapping |

	mappingRuleSetBuilder := MappingRuleSetBuilder new.

	mappingRuleSetBuilder
		add: self triggerJsonDecoderVersion1dot0dot1
		asDefaultDecoderFor: self applicationJsonVersion1dot0dot1
		within: #trigger.

	mappingRuleSetBuilder
		add: self triggerJsonDecoderVersion1dot0dot0
		asDecoderFor: self applicationJsonVersion1dot0dot0
		within: #trigger.

	mappingRuleSetBuilder
		add: self triggerJsonDecoderVersion1dot0dot0
		asDefaultEncoderFor: self applicationJsonVersion1dot0dot0
		within: #trigger.

	self shouldnt: [ mappingRuleSetBuilder build ] raise: Error
]

{ #category : #tests }
MappingRuleSetBuilderTest >> testBuildingFailsBecauseMustProvideDefault [

	| mappingRuleSetBuilder |

	mappingRuleSetBuilder := MappingRuleSetBuilder new.

	mappingRuleSetBuilder
		add: self triggerJsonDecoderVersion1dot0dot0
		asDecoderFor: self applicationJsonVersion1dot0dot0
		within: #triggers.

	self should: [ mappingRuleSetBuilder build ] raise: AssertionFailed
]

{ #category : #accessing }
MappingRuleSetBuilderTest >> triggerJsonDecoderVersion1dot0dot0 [

	^ #triggerJsonDecoderVersion1dot0dot0
]

{ #category : #accessing }
MappingRuleSetBuilderTest >> triggerJsonDecoderVersion1dot0dot1 [
	
	^#triggerJsonDecoderVersion1dot0dot1
]

{ #category : #accessing }
MappingRuleSetBuilderTest >> triggerJsonEncoderVersion1dot0dot0 [
	
	^ #triggerJsonEncoderVersion1dot0dot0
]
