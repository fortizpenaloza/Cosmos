Class {
	#name : #DynamicDecoder,
	#superclass : #Object,
	#instVars : [
		'key',
		'decoders'
	],
	#category : #'Cosmos-API-Common'
}

{ #category : #'instance creation' }
DynamicDecoder class >> determiningDecoderBy: aKey [
	
	^ self new initializeDetermingDecoderBy: aKey
]

{ #category : #configuring }
DynamicDecoder >> decoding: aKey applying: aBlock [
	
	decoders at: aKey put: aBlock 
]

{ #category : #initialization }
DynamicDecoder >> initializeDetermingDecoderBy: aKey [

	key := aKey.
	decoders := Dictionary new
]

{ #category : #decoding }
DynamicDecoder >> value: aDictionary [

	| criteria |

	criteria := aDictionary at: key ifAbsent: [ ObjectNotFound signal: 'Decoding failed' ].

	^ decoders
		at: criteria
		ifPresent: [ :block | block value: aDictionary ]
		ifAbsent: [ ObjectNotFound signal: 'lala' ]
]
