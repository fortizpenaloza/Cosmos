Class {
	#name : #MappingRegistryTest,
	#superclass : #TestCase,
	#category : #'Cosmos-API-Tests-Model'
}

{ #category : #history }
MappingRegistryTest class >> lastStoredRun [
	^ ((Dictionary new) add: (#timeStamp->(DateAndTime basicNew instVarAt: 1 put: 6510; instVarAt: 2 put: (Duration seconds: -10800 nanoSeconds: 0); instVarAt: 3 put: 2458339; instVarAt: 4 put: 623551000; yourself)); add: (#passed->((Set new) add: #testDecoderRegistration; add: #testEncoderRegistration; yourself)); add: (#failures->((Set new))); add: (#errors->((Set new))); yourself)
]

{ #category : #tests }
MappingRegistryTest >> testDecoderRegistration [

	| mappingRegistry mapping |

	mappingRegistry := MappingRegistry new.

	self
		should: [ mappingRegistry decoderFor: self triggerMimeTypeVersion1dot0dot0 ]
		raise: ObjectNotFound
		withDescription: 'Decoder not found for given schema'.

	mappingRegistry
		register: self triggerJsonEncoderVersion1dot0dot0
		 asDecoderFor: self triggerMimeTypeVersion1dot0dot0.

	mapping := mappingRegistry decoderFor: self triggerMimeTypeVersion1dot0dot0.

	self assert: mapping equals: self triggerJsonEncoderVersion1dot0dot0
]

{ #category : #tests }
MappingRegistryTest >> testEncoderRegistration [

	| mappingRegistry mapping |

	mappingRegistry := MappingRegistry new.

	self
		should: [ mappingRegistry encoderFor: self triggerMimeTypeVersion1dot0dot0 ]
		raise: ObjectNotFound
		withDescription: 'Encoder not found for given schema'.

	mappingRegistry
		register: self triggerJsonEncoderVersion1dot0dot0
		 asEncoderFor: self triggerMimeTypeVersion1dot0dot0.

	mapping := mappingRegistry encoderFor: self triggerMimeTypeVersion1dot0dot0.

	self assert: mapping equals: self triggerJsonEncoderVersion1dot0dot0
]

{ #category : #accessing }
MappingRegistryTest >> triggerJsonEncoderVersion1dot0dot0 [
	
	^ #triggerJsonEncoderVersion1dot0dot0
]

{ #category : #accessing }
MappingRegistryTest >> triggerMimeTypeVersion1dot0dot0 [

	^ ZnMimeType fromString: 'application/vnd.cosmos.trigger+json; version=1.0.0'
]
