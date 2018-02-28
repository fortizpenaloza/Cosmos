initialize-release
initializeMappings

	triggersMapping := [ :object | 
	String
		streamContents: [ :stream | 
			(NeoJSONWriter on: stream)
				for: ActionTrigger
					do: [ :mapping | 
					mapping
						mapAccessor: #name;
						mapAccessor: #creationDateTime to: 'created_on';
						mapAccessor: #triggeringPolicy to: 'policy';
						mapAccessor: #action;
						mapAccessor: #condition ];
				for: Action customDo: [ :mapping | mapping encoder: [ :action | action name ] ];
				for: PeriodicalTriggeringPolicy 
					customDo: [ :mapping | 
					mapping
						encoder: [ :policy | 
							{(#type -> #periodical).
							(#time_interval -> (policy instVarNamed: #timePeriod))} asOrderedDictionary  ] ];
				for: AlwaysTriggeringCondition
					customDo: [ :mapping | mapping encoder: [ :condition | 'true' ] ];
				for: Measure customDo: [: mapping | mapping encoder: [:measure | measure printString  ] ]; 
				for: DateTime
					customDo: [ :mapping | 
					mapping
						encoder: [ :dateTime | ISO8601DateTimeFormatter usingExtendedFormat format: dateTime ] ];
				prettyPrint: true;
				nextPut: object ] ]