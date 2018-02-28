private-parsers
triggeringPolicyParser
	
	^  (DynamicParser determiningParserBy: #type)
		parsing: #periodical
			with: [ :json | PeriodicalTriggeringPolicy every: (self parseTimeIntervalFrom: json) ];
		parsing: #data_point_registration
			with:
				[ :json | DataPointRegistrationTriggeringPolicy on: (self parseDataStreamFrom: json) ];
		yourself.