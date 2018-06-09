Class {
	#name : #MappingRegistry,
	#superclass : #Object,
	#instVars : [
		'encoders',
		'decoders'
	],
	#category : #'Cosmos-API-Core-Model'
}

{ #category : #querying }
MappingRegistry >> decoderFor: aSchema [

	^ decoders
		at: aSchema
		ifAbsent: [ ObjectNotFound signal: 'Decoder not found for given schema' ]
]

{ #category : #querying }
MappingRegistry >> encoderFor: aSchema [

	^ encoders
		at: aSchema
		ifAbsent: [ ObjectNotFound signal: 'Encoder not found for given schema' ]
]

{ #category : #initialization }
MappingRegistry >> initialize [

	encoders := Dictionary new.
	decoders := Dictionary new
]

{ #category : #managing }
MappingRegistry >> register: aDecoder asDecoderFor: aMimeType [

	decoders at: aMimeType put: aDecoder
]

{ #category : #managing }
MappingRegistry >> register: anEncoder asEncoderFor: aMimeType [

	encoders at: aMimeType put: anEncoder
]
