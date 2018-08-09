Class {
	#name : #DynamicDecoderTest,
	#superclass : #TestCase,
	#category : #'Cosmos-API-Tests-Decoding'
}

{ #category : #history }
DynamicDecoderTest class >> lastStoredRun [
	^ ((Dictionary new) add: (#timeStamp->(DateAndTime basicNew instVarAt: 1 put: 6510; instVarAt: 2 put: (Duration seconds: -10800 nanoSeconds: 0); instVarAt: 3 put: 2458339; instVarAt: 4 put: 625068000; yourself)); add: (#passed->((Set new) add: #testDecoding; yourself)); add: (#failures->((Set new))); add: (#errors->((Set new))); yourself)
]

{ #category : #tests }
DynamicDecoderTest >> testDecoding [

	| decoder aJson decoded |

	decoder := (DynamicDecoder determiningDecoderBy: #type)
		decoding: #number applying: [ :json | (json at: #amount) asNumber ];
		decoding: #string applying: [ :json | json at: #name ];
		yourself.

	aJson := '{
	"type" : "number",
	"amount" : "5"
}'.

	decoded := decoder value: (STONJSON fromString: aJson).
	self assert: decoded equals: 5.

	aJson := '{
	"type" : "string",
	"name" : "a string"
}'.

	decoded := decoder value: (STONJSON fromString: aJson).
	self assert: decoded equals: 'a string'
]
