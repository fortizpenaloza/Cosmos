Class {
	#name : #TriggerDecoder,
	#superclass : #Object,
	#category : #'Cosmos-API-Triggers'
}

{ #category : #'as yet unclassified' }
TriggerDecoder >> actionDecoder [

	^ [ :name | 
	self actionManagementSystem
		actionNamed: name
		ifFound: [ :action | action ]
		ifNone: [ ObjectNotFound signal: ('Action named <1s> not found' expandMacrosWith: name) ] ]
]

{ #category : #decoding }
TriggerDecoder >> decode: aRawTrigger [

	^ ActionTrigger
		named: (aRawTrigger at: #name)
		triggering: (self decodeActionFrom: aRawTrigger)
		accordingTo: (self decodeTriggeringPolicyFrom: aRawTrigger)
		ifSatisfies: (self decodeTriggeringConditionFrom: aRawTrigger)
]

{ #category : #'as yet unclassified' }
TriggerDecoder >> decodeActionFrom: aRawTrigger [ 
	
	self
		decode: #action
		from: aRawTrigger
		with: self actionDecoder
]
