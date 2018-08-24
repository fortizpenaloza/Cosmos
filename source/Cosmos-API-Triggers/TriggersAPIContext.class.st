Class {
	#name : #TriggersAPIContext,
	#superclass : #Object,
	#instVars : [
		'mappingRegistry',
		'cosmos'
	],
	#category : #'Cosmos-API-Triggers'
}

{ #category : #'instance creation' }
TriggersAPIContext class >> workingWith: aCosmosSystem queryingMappingsTo: aMappingRegistry [

	^ self new initializeWorkingWith: aCosmosSystem queryingMappingsTo: aMappingRegistry
]

{ #category : #'private-decoders' }
TriggersAPIContext >> actionDecoder [

	^ [ :name | 
	self actionManagementSystem
		actionNamed: name
		ifFound: [ :action | action ]
		ifNone: [ DecodingFailed signal: ('Action named <1s> not found' expandMacrosWith: name) ] ]
]

{ #category : #systems }
TriggersAPIContext >> actionManagementSystem [
	
	^ cosmos systemImplementing: #ActionManagementSystemInterface
]

{ #category : #systems }
TriggersAPIContext >> dataManagementSystem [

	^ cosmos systemImplementing: #DataManagementSystemInterface
]

{ #category : #'private-decoders' }
TriggersAPIContext >> dataStreamDecoder [

	^ [ :name | 
	self dataManagementSystem
		streamNamed: name
		ifFound: [ :stream | stream ]
		ifNone: [ DecodingFailed signal: ('Data stream named <1s> not found' expandMacrosWith: name) ] ]
]

{ #category : #'private-decoding' }
TriggersAPIContext >> decode: aKey from: aDictionary with: aDecodingBlock [

	^ aDictionary
		at: aKey
		ifPresent: [ :rawData | aDecodingBlock value: rawData ]
		ifAbsent:
			[ DecodingFailed signal: ('<1s> key is mandatory and must be present' expandMacrosWith: aKey) ]
]

{ #category : #'private-decoding' }
TriggersAPIContext >> decodeActionFrom: aJSON [

	^ self
		decode: #action
		from: aJSON
		with: self actionDecoder
]

{ #category : #'private-decoding' }
TriggersAPIContext >> decodeDataStreamFrom: aJSON [

	^ self
		decode: #data_stream
		from: aJSON
		with: self dataStreamDecoder
]

{ #category : #'private-decoding' }
TriggersAPIContext >> decodeTimeIntervalFrom: aJSON [

	^ self
		decode: #time_interval
		from: aJSON
		with: self timeIntervalDecoder
]

{ #category : #'private-decoding' }
TriggersAPIContext >> decodeTriggeringConditionFrom: aJSON [

	^ AlwaysTriggeringCondition new
]

{ #category : #'private-decoding' }
TriggersAPIContext >> decodeTriggeringPolicyFrom: aJSON [ 
	
	^ self decode: #policy from: aJSON with: self triggeringPolicyDecoder
]

{ #category : #encoding }
TriggersAPIContext >> encode: aTriggerCollection to: aMediaType within: aKeyRepresentingScope [

	^ (mappingRegistry encoderFor: aMediaType within: aKeyRepresentingScope)
		value: aTriggerCollection
]

{ #category : #initialization }
TriggersAPIContext >> initializeWorkingWith: aCosmosSystem queryingMappingsTo: aMappingRegistry [

	cosmos := aCosmosSystem.
	mappingRegistry := aMappingRegistry
]

{ #category : #decoding }
TriggersAPIContext >> register: anEncodedTrigger encodedAs: aMimeType [

	| decoder |

	decoder := mappingRegistry decoderFor: aMimeType within: #triggers.
	decoder cull: anEncodedTrigger cull: self
]

{ #category : #'private-decoders' }
TriggersAPIContext >> timeIntervalDecoder [

	^ [ :string | TimeUnits minute with: 5 ]
]

{ #category : #systems }
TriggersAPIContext >> triggerManagementSystem [

	^ cosmos systemImplementing: #TriggerManagementSystemInterface
]

{ #category : #'private-decoders' }
TriggersAPIContext >> triggeringPolicyDecoder [

	^ (DynamicDecoder determiningDecoderBy: #type)
		decoding: #periodical
			applying: [ :json | PeriodicalTriggeringPolicy every: (self decodeTimeIntervalFrom: json) ];
		decoding: #data_point_registration
			applying:
				[ :json | DataPointRegistrationTriggeringPolicy on: (self decodeDataStreamFrom: json) ];
		yourself
]
