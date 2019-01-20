Class {
	#name : #ConditionDecoder,
	#superclass : #Object,
	#category : #'Cosmos-API-Triggers'
}

{ #category : #decoding }
ConditionDecoder >> decode: aDictionary [

	| decoderByType |

	decoderByType := Dictionary new
		at: '>'
			put: [ ArithmeticCondition
				comparingAgainst: (aDictionary at: #value)
				using: #> ];
		yourself.

	^ (decoderByType at: (aDictionary at: #operator)) value
]
