"
An UUIDProviderTest is a test class for testing the behavior of UUIDProvider
"
Class {
	#name : #UUIDProviderTest,
	#superclass : #TestCase,
	#category : #'Cosmos-Identifier-Tests'
}

{ #category : #tests }
UUIDProviderTest >> testNext [

	| uuid |

	uuid := UUIDProvider new next.

	self
		assert: uuid size equals: 16;
		deny: uuid isNilUUID;
		deny: uuid = UUID new
]
