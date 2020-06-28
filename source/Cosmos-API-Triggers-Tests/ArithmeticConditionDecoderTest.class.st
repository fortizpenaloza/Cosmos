"
A ConditionDecoderTest is a test class for testing the behavior of ConditionDecoder
"
Class {
	#name : #ArithmeticConditionDecoderTest,
	#superclass : #TestCase,
	#category : #'Cosmos-API-Triggers-Tests'
}

{ #category : #tests }
ArithmeticConditionDecoderTest >> encodeAsJson: json [

	^ NeoJSONReader fromString: json
]

{ #category : #tests }
ArithmeticConditionDecoderTest >> testDifferent [

	| condition json |

	json := '{
	"operator": "~=",
	"value": 1
}'.

	condition := ArithmeticConditionDecoder new decode: (self encodeAsJson: json).

	self
		deny: (condition isSatisfiedBy: 1);
		assert: (condition isSatisfiedBy: 0);
		assert: (condition isSatisfiedBy: 2)
]

{ #category : #tests }
ArithmeticConditionDecoderTest >> testEquals [

	| condition json |

	json := '{
	"operator": "=",
	"value": 1
}'.

	condition := ArithmeticConditionDecoder new decode: (self encodeAsJson: json).

	self
		assert: (condition isSatisfiedBy: 1);
		deny: (condition isSatisfiedBy: 0);
		deny: (condition isSatisfiedBy: 2)
]

{ #category : #tests }
ArithmeticConditionDecoderTest >> testEqualsToNil [

	| condition json |

	json := '{
	"operator": "=",
	"value": null
}'.

	condition := ArithmeticConditionDecoder new decode: (self encodeAsJson: json).

	self
		assert: (condition isSatisfiedBy: nil);
		deny: (condition isSatisfiedBy: 0);
		deny: (condition isSatisfiedBy: 'hola')
]

{ #category : #tests }
ArithmeticConditionDecoderTest >> testFailedIfOperatorNotFound [

	| json |

	json := '{
	"operator": "//",
	"value": 1
}'.

	self
		should: [ ArithmeticConditionDecoder new decode: (self encodeAsJson: json) ]
		raise: KeyNotFound
		withMessageText: 'key ''//'' not found in Dictionary'
]

{ #category : #tests }
ArithmeticConditionDecoderTest >> testGreaterOrEqualThan [

	| condition json |

	json := '{
	"operator": ">=",
	"value": 1
}'.

	condition := ArithmeticConditionDecoder new decode: (self encodeAsJson: json).

	self
		deny: (condition isSatisfiedBy: 0);
		assert: (condition isSatisfiedBy: 1);
		assert: (condition isSatisfiedBy: 2)
]

{ #category : #tests }
ArithmeticConditionDecoderTest >> testGreaterThan [

	| condition json |

	json := '{
	"operator": ">",
	"value": 1
}'.

	condition := ArithmeticConditionDecoder new decode: (self encodeAsJson: json).

	self
		deny: (condition isSatisfiedBy: 0);
		deny: (condition isSatisfiedBy: 1);
		assert: (condition isSatisfiedBy: 2)
]

{ #category : #tests }
ArithmeticConditionDecoderTest >> testLessOrEqualThan [

	| condition json |

	json := '{
	"operator": "<=",
	"value": 1
}'.

	condition := ArithmeticConditionDecoder new decode: (self encodeAsJson: json).

	self
		assert: (condition isSatisfiedBy: 0);
		assert: (condition isSatisfiedBy: 1);
		deny: (condition isSatisfiedBy: 2)
]

{ #category : #tests }
ArithmeticConditionDecoderTest >> testLessThan [

	| condition json |

	json := '{
	"operator": "<",
	"value": 1
}'.

	condition := ArithmeticConditionDecoder new decode: (self encodeAsJson: json).

	self
		assert: (condition isSatisfiedBy: 0);
		deny: (condition isSatisfiedBy: 1);
		deny: (condition isSatisfiedBy: 2)
]
