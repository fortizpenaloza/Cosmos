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
			put: [ ArithmeticCondition toBeGreaterThan: (aDictionary at: #value) ];
		at: '>='
			put: [ ArithmeticCondition toBeGreaterOrEqualThan: (aDictionary at: #value) ];
		at: '='
			put: [ ArithmeticCondition toBeEqualTo: (aDictionary at: #value) ];
		at: '~='
			put: [ ArithmeticCondition toBeDifferentTo: (aDictionary at: #value) ];
		at: '<'
			put: [ ArithmeticCondition toBeLessThan: (aDictionary at: #value) ];
		at: '<='
			put: [ ArithmeticCondition toBeLessOrEqualThan: (aDictionary at: #value) ];
		yourself.

	^ (decoderByType at: (aDictionary at: #operator)) value
]
