tests
testParsing

	| parser triggerJSON policy context |

	context := TriggersAPIContext workingWith: nil.

	parser := (DynamicParser determiningParserBy: #type)
		parsing: #periodical
			with: [ :json | PeriodicalTriggeringPolicy every: (context parseTimeIntervalFrom: json) ];
		parsing: #data_point_registration
			with:
				[ :json | DataPointRegistrationTriggeringPolicy on: (context parseDataStreamFrom: json) ];
		yourself.

	triggerJSON := '{
	"type" : "periodical",
	"time_interval" : "5 minutes"
}'.

	policy := parser parse: (STONJSON fromString: triggerJSON).

	self assert: (policy isKindOf: PeriodicalTriggeringPolicy)