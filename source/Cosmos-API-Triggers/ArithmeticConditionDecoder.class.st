Class {
	#name : #ArithmeticConditionDecoder,
	#superclass : #Decoder,
	#category : #'Cosmos-API-Triggers'
}

{ #category : #decoding }
ArithmeticConditionDecoder >> decode: aJson [

	| decoderByType |

	decoderByType := Dictionary new
		at: '>' put: [ ArithmeticCondition toBeGreaterThan: ( aJson at: #value ) ];
		at: '>=' put: [ ArithmeticCondition toBeGreaterOrEqualThan: ( aJson at: #value ) ];
		at: '=' put: [ ArithmeticCondition toBeEqualTo: ( aJson at: #value ) ];
		at: '~=' put: [ ArithmeticCondition toBeDifferentTo: ( aJson at: #value ) ];
		at: '<' put: [ ArithmeticCondition toBeLessThan: ( aJson at: #value ) ];
		at: '<=' put: [ ArithmeticCondition toBeLessOrEqualThan: ( aJson at: #value ) ];
		yourself.

	^ ( decoderByType at: ( aJson at: #operator ) ) value
]
