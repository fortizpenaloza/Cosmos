Class {
	#name : #DynamicParserTest,
	#superclass : #TestCase,
	#category : #'Cosmos-API-Tests-Decoding'
}

{ #category : #tests }
DynamicParserTest >> testParsing [

	| parser triggerJSON policy context |

	context := TriggersAPIContext
		workingWith: nil
		queryingMappingsTo: MappingRegistry new.

	parser := (DynamicParser determiningParserBy: #type)
		parsing: #periodical
			with:
				[ :json | PeriodicalTriggeringPolicy every: (context decodeTimeIntervalFrom: json) ];
		parsing: #data_point_registration
			with: [ :json | 
			DataPointRegistrationTriggeringPolicy
				on: (context decodeDataStreamFrom: json) ];
		yourself.

	triggerJSON := '{
	"type" : "periodical",
	"time_interval" : "5 minutes"
}'.

	policy := parser value: (STONJSON fromString: triggerJSON).

	self assert: (policy isKindOf: PeriodicalTriggeringPolicy)
]
