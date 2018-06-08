Class {
	#name : #TriggersAPIContext,
	#superclass : #Object,
	#instVars : [
		'cosmosSystem',
		'mappingRegistry'
	],
	#category : #'Cosmos-API-Triggers-Model'
}

{ #category : #'instance creation' }
TriggersAPIContext class >> workingWith: aCosmosSystem queryingMappingsTo: aMappingRegistry [

	^ self new initializeWorkingWith: aCosmosSystem queryingMappingsTo: aMappingRegistry
]

{ #category : #systems }
TriggersAPIContext >> actionManagementSystem [
	
	^ cosmosSystem systemImplementing: #ActionManagementSystemInterface
]

{ #category : #'private-parsers' }
TriggersAPIContext >> actionParser [

	^ BlockToParserAdapter
		onParsingEvaluate: [ :string | 
			self actionManagementSystem
				actionNamed: string
				ifFound: [ :action | action ]
				ifNone: [ Error signal: 'Action not found' ] ]
]

{ #category : #systems }
TriggersAPIContext >> dataManagementSystem [

	^ cosmosSystem systemImplementing: #DataManagementSystemInterface
]

{ #category : #'private-parsers' }
TriggersAPIContext >> dataStreamParser [

	^ BlockToParserAdapter
		onParsingEvaluate: [ :string | 
			self dataManagementSystem
				streamNamed: string
				ifFound: [ :stream | stream ]
				ifNone: [ Error signal: 'aca loco' ] ]
]

{ #category : #mapping }
TriggersAPIContext >> encode: anActionTrigger to: aMimeType [

	| encoder |

	encoder := mappingRegistry mappingFor: aMimeType.

	^ encoder value: anActionTrigger
]

{ #category : #initialization }
TriggersAPIContext >> initializeWorkingWith: aCosmosSystem [ 

	cosmosSystem := aCosmosSystem 
]

{ #category : #initialization }
TriggersAPIContext >> initializeWorkingWith: aCosmosSystem queryingMappingsTo: aMappingRegistry [

	cosmosSystem := aCosmosSystem.
	mappingRegistry := aMappingRegistry
]

{ #category : #'private-parsing' }
TriggersAPIContext >> parse: aKey from: aDictionary with: aParser [

	^ self
		parse: aKey
		from: aDictionary
		with: aParser
		ifNotFound: [ ParsingFailed signal: ('<1s> is mandatory and must be present' expandMacrosWith: aKey) ]
]

{ #category : #'private-parsing' }
TriggersAPIContext >> parse: aKey from: aDictionary with: aParser ifNotFound: aNotFoundBlock [

	^ aDictionary
		at: aKey
		ifPresent: [ :rawData | aParser parse: rawData ]
		ifAbsent: aNotFoundBlock
]

{ #category : #parsing }
TriggersAPIContext >> parseActionFrom: aJSON [

	^ self
		parse: #action
		from: aJSON
		with: self actionParser
		ifNotFound: [ self halt ]
]

{ #category : #parsing }
TriggersAPIContext >> parseConditionFrom: aJSON [

	^ AlwaysTriggeringCondition new
]

{ #category : #parsing }
TriggersAPIContext >> parseDataStreamFrom: aJSON [

	^ self
		parse: #data_stream
		from: aJSON
		with: self dataStreamParser
		ifNotFound: [ self halt ]
]

{ #category : #parsing }
TriggersAPIContext >> parseTimeIntervalFrom: aJSON [

	^ self
		parse: #time_interval
		from: aJSON
		with: self timeIntervalParser
		ifNotFound: [ self halt ]
]

{ #category : #parsing }
TriggersAPIContext >> parseTriggeringPolicyFrom: aJSON [ 
	
	^ self parse: #policy from: aJSON with: self triggeringPolicyParser
]

{ #category : #'private-parsers' }
TriggersAPIContext >> timeIntervalParser [

	^ BlockToParserAdapter onParsingEvaluate: [ :string | TimeUnits minute with: 5 ]
]

{ #category : #systems }
TriggersAPIContext >> triggerManagementSystem [

	^ cosmosSystem systemImplementing: #TriggerManagementSystemInterface
]

{ #category : #'private-parsers' }
TriggersAPIContext >> triggeringPolicyParser [
	
	^  (DynamicParser determiningParserBy: #type)
		parsing: #periodical
			with: [ :json | PeriodicalTriggeringPolicy every: (self parseTimeIntervalFrom: json) ];
		parsing: #data_point_registration
			with:
				[ :json | DataPointRegistrationTriggeringPolicy on: (self parseDataStreamFrom: json) ];
		yourself.
]
