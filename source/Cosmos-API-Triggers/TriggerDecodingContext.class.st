Class {
	#name : #TriggerDecodingContext,
	#superclass : #Object,
	#instVars : [
		'cosmos'
	],
	#category : #'Cosmos-API-Triggers'
}

{ #category : #'instance creation' }
TriggerDecodingContext class >> workingWith: aCosmosSystem [

	^ self new initializeWorkingWith: aCosmosSystem
]

{ #category : #'private - decoders' }
TriggerDecodingContext >> actionDecoder [

	^ [ :name | 
	self actionManagementSystem
		actionNamed: name
		ifFound: [ :action | action ]
		ifNone: [ DecodingFailed signal: ('Action named <1s> not found' expandMacrosWith: name) ] ]
]

{ #category : #systems }
TriggerDecodingContext >> actionManagementSystem [
	
	^ cosmos systemImplementing: #ActionManagementSystemInterface
]

{ #category : #systems }
TriggerDecodingContext >> dataManagementSystem [

	^ cosmos systemImplementing: #DataManagementSystemInterface
]

{ #category : #'private - decoders' }
TriggerDecodingContext >> dataStreamDecoder [

	^ [ :name | 
	self dataManagementSystem
		streamNamed: name
		ifFound: [ :stream | stream ]
		ifNone: [ DecodingFailed signal: ('Data stream named <1s> not found' expandMacrosWith: name) ] ]
]

{ #category : #'private - decoding' }
TriggerDecodingContext >> decode: aKey from: aDictionary with: aDecodingBlock [

	^ aDictionary
		at: aKey
		ifPresent: [ :rawData | aDecodingBlock value: rawData ]
		ifAbsent:
			[ DecodingFailed signal: ('<1s> key is mandatory and must be present' expandMacrosWith: aKey) ]
]

{ #category : #'private - decoding' }
TriggerDecodingContext >> decodeActionFrom: aJSON [

	^ self
		decode: #action
		from: aJSON
		with: self actionDecoder
]

{ #category : #'private - decoding' }
TriggerDecodingContext >> decodeDataStreamFrom: aJSON [

	^ self
		decode: #data_stream
		from: aJSON
		with: self dataStreamDecoder
]

{ #category : #'private - decoding' }
TriggerDecodingContext >> decodeTimeIntervalFrom: aJSON [

	^ self
		decode: #time_interval
		from: aJSON
		with: self timeIntervalDecoder
]

{ #category : #'private - decoding' }
TriggerDecodingContext >> decodeTriggeringConditionFrom: aJSON [

	^ AlwaysTriggeringCondition new
]

{ #category : #'private - decoding' }
TriggerDecodingContext >> decodeTriggeringPolicyFrom: aJSON [ 
	
	^ self decode: #policy from: aJSON with: self triggeringPolicyDecoder
]

{ #category : #initialization }
TriggerDecodingContext >> initializeWorkingWith: aCosmosSystem [

	cosmos := aCosmosSystem
]

{ #category : #'private - decoders' }
TriggerDecodingContext >> timeIntervalDecoder [

	^ [ :string | TimeUnits minute with: 5 ]
]

{ #category : #'private - decoders' }
TriggerDecodingContext >> triggeringPolicyDecoder [

	^ (DynamicDecoder determiningDecoderBy: #type)
		decoding: #periodical
			applying: [ :json | PeriodicalTriggeringPolicy every: (self decodeTimeIntervalFrom: json) ];
		decoding: #data_point_registration
			applying: [ :json | DataPointRegistrationTriggeringPolicy on: (self decodeDataStreamFrom: json) ];
		yourself
]
