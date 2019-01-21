"
A TriggeringPolicyDecoderTest is a test class for testing the behavior of TriggeringPolicyDecoder
"
Class {
	#name : #TriggeringPolicyDecoderTest,
	#superclass : #TestCase,
	#category : #'Cosmos-API-Triggers-Tests'
}

{ #category : #'private - mock' }
TriggeringPolicyDecoderTest >> >> anInterface [
	
]

{ #category : #'private - utility' }
TriggeringPolicyDecoderTest >> encodeAsJson: aString [

	^ NeoJSONReader fromString: aString
]

{ #category : #mock }
TriggeringPolicyDecoderTest >> streamNamed: aName [

	self assert: aName equals: 'Temperature'.

	^ DataStream named: aName
]

{ #category : #tests }
TriggeringPolicyDecoderTest >> testDecodingDataPointRegistrationTriggeringPolicy [

	| json policy |
	
	json := '{
	"type" : "data_point_registration",
	"data_stream" : "Temperature"
}'.

	policy := (TriggeringPolicyDecoder using: self) decode: (self encodeAsJson: json).

	self assert: true
	
]

{ #category : #tests }
TriggeringPolicyDecoderTest >> testDecodingPeriodicalTriggeringPolicy [

	| json |
	
	json := '{
	"type" : "periodical",
	"time_interval" : "5 minutes"
}'.

	(TriggeringPolicyDecoder using: self) decode: (self encodeAsJson: json).

	self assert: true
	
]
