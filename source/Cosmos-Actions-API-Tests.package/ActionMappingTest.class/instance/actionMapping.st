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
						mapAccessor: #creationDateTime to: #created_on;
						mapInstVar: #evaluationPolicy to: #http_request];
				for: ZnRequest do: [ :mapping | 
					mapping
						mapAccessor: #requestLine to: #request_line;
						mapAccessor: #headers;
						mapAccessor: #entity ];
				for: ZnRequestLine do: [ :mapping | 
					mapping
						mapAccessor: #method;
						mapAccessor: #uri;
						mapInstVar: #version ];
				for: ZnUrl customDo: [ :mapping |
					mapping
						encoder: [ :url | url printString ] ];
				for: ZnHeaders do: [ :mapping |
					mapping
						mapAccessor: #headers ];
				for: DateTime customDo: [ :mapping | 
					mapping
						encoder: [ :dateTime | ISO8601DateTimeFormatter usingExtendedFormat format: dateTime ] ];
				prettyPrint: true;
				nextPut: action ] ]