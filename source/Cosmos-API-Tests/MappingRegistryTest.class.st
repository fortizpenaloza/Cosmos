Class {
	#name : #MappingRegistryTest,
	#superclass : #TestCase,
	#category : #'Cosmos-API-Tests-Model'
}

{ #category : #history }
MappingRegistryTest class >> lastStoredRun [
	^ ((Dictionary new) add: (#timeStamp->(DateAndTime basicNew instVarAt: 1 put: 6510; instVarAt: 2 put: (Duration seconds: -10800 nanoSeconds: 0); instVarAt: 3 put: 2458339; instVarAt: 4 put: 623551000; yourself)); add: (#passed->((Set new) add: #testRegisteringDecoder; add: #testRegisteringEncoder; yourself)); add: (#failures->((Set new))); add: (#errors->((Set new))); yourself)
]

{ #category : #accessing }
MappingRegistryTest >> applicationJsonVersion1dot0dot0 [

	^ ZnMimeType fromString: 'application/json; version=1.0.0'
]

{ #category : #accessing }
MappingRegistryTest >> applicationJsonVersion1dot0dot1 [

	^ ZnMimeType fromString: 'application/json; version=1.0.1'
]

{ #category : #tests }
MappingRegistryTest >> testQueryingDecoderForAnyMimeType [

	| mappingRegistry mapping |

	mappingRegistry := MappingRegistry new.

	mappingRegistry
		add: self triggerJsonDecoderVersion1dot0dot0
		asDecoderFor: self applicationJsonVersion1dot0dot0
		at: #triggers.

	mapping := mappingRegistry decoderFor: ZnMimeType any at: #triggers.
	self assert: mapping equals: self triggerJsonDecoderVersion1dot0dot0
]

{ #category : #tests }
MappingRegistryTest >> testQueryingDecoderSpecificVersion [

	| mappingRegistry mapping |

	mappingRegistry := MappingRegistry new.

	mappingRegistry
		add: self triggerJsonDecoderVersion1dot0dot0
		asDecoderFor: self applicationJsonVersion1dot0dot0
		at: #triggers.

	mappingRegistry
		add: self triggerJsonDecoderVersion1dot0dot1
		asDecoderFor: self applicationJsonVersion1dot0dot1
		at: #triggers.

	mapping := mappingRegistry
		decoderFor: self applicationJsonVersion1dot0dot1
		at: #triggers.
	self assert: mapping equals: self triggerJsonDecoderVersion1dot0dot1
]

{ #category : #tests }
MappingRegistryTest >> testQueryingDefaultDecoderForAnyMimeType [

	| mappingRegistry mapping |

	mappingRegistry := MappingRegistry new.

	mappingRegistry
		add: self triggerJsonDecoderVersion1dot0dot0
		asDecoderFor: self applicationJsonVersion1dot0dot0
		at: #triggers.

	mappingRegistry
		add: self triggerJsonDecoderVersion1dot0dot1
		asDefaultDecoderFor: self applicationJsonVersion1dot0dot1
		at: #triggers.

	mapping := mappingRegistry decoderFor: ZnMimeType any at: #triggers.
	self assert: mapping equals: self triggerJsonDecoderVersion1dot0dot0
]

{ #category : #tests }
MappingRegistryTest >> testRegisteringDecoder [

	| mappingRegistry mapping |

	mappingRegistry := MappingRegistry new.

	self
		should: [ mappingRegistry
				decoderFor: self applicationJsonVersion1dot0dot0
				at: nil ]
		raise: ObjectNotFound
		withDescription: 'Decoder not found for given MIME type'.

	mappingRegistry
		add: self triggerJsonEncoderVersion1dot0dot0
		asDecoderFor: self applicationJsonVersion1dot0dot0
		at: #trigger.

	mapping := mappingRegistry
		decoderFor: self applicationJsonVersion1dot0dot0
		at: #trigger.

	self assert: mapping equals: self triggerJsonEncoderVersion1dot0dot0
]

{ #category : #tests }
MappingRegistryTest >> testRegisteringDecoderFailsIfAlreadyExist [

	| mappingRegistry |

	mappingRegistry := MappingRegistry new.

	mappingRegistry
		add: self triggerJsonDecoderVersion1dot0dot0
		asDecoderFor: ZnMimeType textPlain
		at: aKeyRepresentingDomainObject.

	self
		should: [ mappingRegistry
				add: self triggerJsonEncoderVersion1dot0dot0
				asDecoderFor: ZnMimeType textPlain
				at: aKeyRepresentingDomainObject ]
		raise: ConflictingObjectFound
]

{ #category : #tests }
MappingRegistryTest >> testRegisteringEncoder [

	| mappingRegistry mapping |

	mappingRegistry := MappingRegistry new.

	self
		should: [ mappingRegistry
				encoderFor: self applicationJsonVersion1dot0dot0
				at: nil ]
		raise: ObjectNotFound
		withDescription: 'Encoder not found for given MIME type'.

	mappingRegistry
		add: self triggerJsonEncoderVersion1dot0dot0
		asEncoderFor: self applicationJsonVersion1dot0dot0
		at: #triggers.

	mapping := mappingRegistry
		encoderFor: self applicationJsonVersion1dot0dot0
		at: #triggers.

	self assert: mapping equals: self triggerJsonEncoderVersion1dot0dot0
]

{ #category : #tests }
MappingRegistryTest >> testRegisteringEncoderFailsIfAlreadyExist [

	| mappingRegistry |

	mappingRegistry := MappingRegistry new.

	mappingRegistry
		add: self triggerJsonEncoderVersion1dot0dot0
		asEncoderFor: ZnMimeType textPlain
		at: #triggers.

	self
		should: [ mappingRegistry
				add: self triggerJsonEncoderVersion1dot0dot0
				asEncoderFor: ZnMimeType textPlain
				at: #triggers ]
		raise: ConflictingObjectFound
]

{ #category : #tests }
MappingRegistryTest >> testRegisteringMultipleVersionDecoders [

	| mappingRegistry mapping |

	mappingRegistry := MappingRegistry new.

	mappingRegistry
		add: self triggerJsonDecoderVersion1dot0dot0
		asDecoderFor: self applicationJsonVersion1dot0dot0
		at: #triggers.

	mappingRegistry
		add: self triggerJsonDecoderVersion1dot0dot1
		asDecoderFor: self applicationJsonVersion1dot0dot1
		at: #triggers.

	mapping := mappingRegistry
		decoderFor: self applicationJsonVersion1dot0dot0
		at: #triggers.
	self assert: mapping equals: self triggerJsonDecoderVersion1dot0dot0.

	mapping := mappingRegistry
		decoderFor: self applicationJsonVersion1dot0dot1
		at: #triggers.
	self assert: mapping equals: self triggerJsonDecoderVersion1dot0dot1
]

{ #category : #accessing }
MappingRegistryTest >> triggerJsonDecoderVersion1dot0dot0 [

	^ #triggerJsonDecoderVersion1dot0dot0
]

{ #category : #accessing }
MappingRegistryTest >> triggerJsonDecoderVersion1dot0dot1 [

	^ #triggerJsonDecoderVersion1dot0dot1
]

{ #category : #accessing }
MappingRegistryTest >> triggerJsonEncoderVersion1dot0dot0 [
	
	^ #triggerJsonEncoderVersion1dot0dot0
]
