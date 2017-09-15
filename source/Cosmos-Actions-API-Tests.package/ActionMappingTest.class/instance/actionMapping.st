as yet unclassified
actionMapping

	^ [ :action | 
	String
		streamContents: [ :stream | 
			(NeoJSONWriter on: stream)
				for: Action
					do: [ :mapping | 
					mapping
						mapAccessor: #name;
						mapAccessor: #creationDateTime;
						mapInstVar: #evaluationPolicy ];
				for: DateTime customDo: [ :mapping | 
					mapping
						encoder: [ :dateTime | ISO8601DateTimeFormatter usingExtendedFormat format: dateTime ] ];
				prettyPrint: true;
				nextPut: action ] ]