"
A ConditionDecoderTest is a test class for testing the behavior of ConditionDecoder
"
Class {
	#name : #ConditionDecoderTest,
	#superclass : #TestCase,
	#category : #'Cosmos-API-Triggers-Tests'
}

{ #category : #tests }
ConditionDecoderTest >> encodeAsJson: json [

	^ NeoJSONReader fromString: json
]

{ #category : #tests }
ConditionDecoderTest >> testDifferent [

	| condition json |

	json := '{
	"operator": "~=",
	"value": 1
}'.

	condition := ConditionDecoder new decode: (self encodeAsJson: json).

	self
		deny: (condition isSatisfiedBy: 1);
		assert: (condition isSatisfiedBy: 0);
		assert: (condition isSatisfiedBy: 2)
]

{ #category : #tests }
ConditionDecoderTest >> testEquals [

	| condition json |

	json := '{
	"operator": "=",
	"value": 1
}'.

	condition := ConditionDecoder new decode: (self encodeAsJson: json).

	self
		assert: (condition isSatisfiedBy: 1);
		deny: (condition isSatisfiedBy: 0);
		deny: (condition isSatisfiedBy: 2)
]

{ #category : #tests }
ConditionDecoderTest >> testFailedIfOperatorNotFound [

	| json |

	json := '{
	"operator": "//",
	"value": 1
}'.

	self
		should: [ ConditionDecoder new decode: (self encodeAsJson: json) ]
		raise: KeyNotFound
		withMessageText: 'key ''//'' not found in Dictionary'
]

{ #category : #tests }
ConditionDecoderTest >> testGreaterOrEqualThan [

	| condition json |

	json := '{
	"operator": ">=",
	"value": 1
}'.

	condition := ConditionDecoder new decode: (self encodeAsJson: json).

	self
		deny: (condition isSatisfiedBy: 0);
		assert: (condition isSatisfiedBy: 1);
		assert: (condition isSatisfiedBy: 2)
]

{ #category : #tests }
ConditionDecoderTest >> testGreaterThan [

	| condition json |

	json := '{
	"operator": ">",
	"value": 1
}'.

	condition := ConditionDecoder new decode: (self encodeAsJson: json).

	self
		deny: (condition isSatisfiedBy: 0);
		deny: (condition isSatisfiedBy: 1);
		assert: (condition isSatisfiedBy: 2)
]

{ #category : #tests }
ConditionDecoderTest >> testLessOrEqualThan [

	| condition json |

	json := '{
	"operator": "<=",
	"value": 1
}'.

	condition := ConditionDecoder new decode: (self encodeAsJson: json).

	self
		assert: (condition isSatisfiedBy: 0);
		assert: (condition isSatisfiedBy: 1);
		deny: (condition isSatisfiedBy: 2)
]

{ #category : #tests }
ConditionDecoderTest >> testLessThan [

	| condition json |

	json := '{
	"operator": "<",
	"value": 1
}'.

	condition := ConditionDecoder new decode: (self encodeAsJson: json).

	self
		assert: (condition isSatisfiedBy: 0);
		deny: (condition isSatisfiedBy: 1);
		deny: (condition isSatisfiedBy: 2)
]
