Class {
	#name : #IsUUIDTest,
	#superclass : #TestCase,
	#category : #'Cosmos-API-Tests-Model'
}

{ #category : #tests }
IsUUIDTest >> testMatches [

	| first second third |

	first := UUID fromString: '0608b9dc-02e4-4dd0-9f8a-ea45160df641'.
	second := UUID fromString: 'e85ae7ba-3ca3-4bae-9f62-cc2ce51c525e'.
	third := UUID fromString: 'adssas'.

	self
		assert: (IsUUID matchesTo: first asString36);
		assert: (IsUUID matchesTo: second asString36)
]

{ #category : #tests }
IsUUIDTest >> testParseString [

	| first second |

	first := UUID fromString: '0608b9dc-02e4-4dd0-9f8a-ea45160df641'.
	second := UUID fromString: 'e85ae7ba-3ca3-4bae-9f62-cc2ce51c525e'.

	self
		assert: (IsUUID parseString: first asString36) equals: first;
		assert: (IsUUID parseString: second asString36) equals: second
]
