Class {
	#name : #TriggeringConditionDecoder,
	#superclass : #Decoder,
	#instVars : [
		'cosmos',
		'decoderByType'
	],
	#category : #'Cosmos-API-Triggers'
}

{ #category : #'instance creation' }
TriggeringConditionDecoder class >> using: aCosmosSystem [
	
	^ self new initializeUsing: aCosmosSystem 
]

{ #category : #'private - decoders' }
TriggeringConditionDecoder >> conditionDecoder [
	
	^ ArithmeticConditionDecoder new
]

{ #category : #'private - decoding' }
TriggeringConditionDecoder >> conditionFrom: aDictionary [

	^ self
		decode: #condition
		from: aDictionary
		using: self conditionDecoder
]

{ #category : #'private - decoders' }
TriggeringConditionDecoder >> dataStreamDecoder [

	^ WellKnownObjectDecoder
		querying: cosmos >> #DataStreamManagementSystemInterface
		sending: #streamNamed:
]

{ #category : #'private - decoding' }
TriggeringConditionDecoder >> dataStreamFrom: rawTriggeringCondition [

	^ self
		decode: #data_stream
		from: rawTriggeringCondition
		using: self dataStreamDecoder
]

{ #category : #decoding }
TriggeringConditionDecoder >> decode: aRawTriggeringConditionCollection [

	^ aRawTriggeringConditionCollection isEmpty
		ifTrue: [ AlwaysTriggeringCondition new ]
		ifFalse: [ aRawTriggeringConditionCollection size = 1
				ifTrue: [ (decoderByType
						at: (aRawTriggeringConditionCollection anyOne at: #type))
						value: aRawTriggeringConditionCollection anyOne ]
				ifFalse: [ AndCompositeTriggeringCondition
						withAll:
							(aRawTriggeringConditionCollection
								collect: [ :rawTriggeringCondition | 
									(decoderByType at: (rawTriggeringCondition at: #type))
										value: rawTriggeringCondition ]) ] ]
]

{ #category : #initialization }
TriggeringConditionDecoder >> initializeDecoderByType [

	decoderByType := Dictionary new
		at: #data_stream_current_value
			put: [ :rawTriggeringCondition | 
			DataStreamCurrentValueTriggeringCondition
				of: (self dataStreamFrom: rawTriggeringCondition)
				comparingWith: (self conditionFrom: rawTriggeringCondition) ];
		at: #data_stream_has_not_been_updated
			put: [ :rawTriggeringCondition | 
			DataStreamHasNotBeenUpdatedTriggeringCondition
				checkingIf: (self dataStreamFrom: rawTriggeringCondition)
				hasNotBeenUpdatedForMoreThan: (self timePeriodFrom: rawTriggeringCondition) ];
		at: #time_interval
			put: [ :rawTriggeringCondition | 
			TimeIntervalTriggeringCondition
				checkingCurrentTimeIsBetween: (self timeIntervalFrom: rawTriggeringCondition) ];
		yourself
]

{ #category : #initialization }
TriggeringConditionDecoder >> initializeUsing: aCosmosSystem [

	cosmos := aCosmosSystem.
	self initializeDecoderByType.
]

{ #category : #'private - decoders' }
TriggeringConditionDecoder >> timeIntervalDecoder [

	^ TimeIntervalDecoder new
]

{ #category : #'private - decoding' }
TriggeringConditionDecoder >> timeIntervalFrom: aDictionary [

	^ self
		decode: #time_interval
		from: aDictionary
		using: self timeIntervalDecoder
]

{ #category : #'private - decoders' }
TriggeringConditionDecoder >> timePeriodDecoder [

	^ TimePeriodDecoder new 
]

{ #category : #'private - decoding' }
TriggeringConditionDecoder >> timePeriodFrom: aDictionary [

	^ self
		decode: #time_period
		from: aDictionary
		using: self timePeriodDecoder
]
