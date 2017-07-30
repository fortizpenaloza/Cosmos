initialize-release
initializeMappings

	prioritizedCommandMapping := [ :object | 
	String
		streamContents: [ :stream | 
			(NeoJSONWriter on: stream)
				for: PrioritizedCommand
					do: [ :mapping | 
					mapping
						mapAccessor: #command;
						mapAccessor: #priority ];
				for: HighPriority customDo: [ :mapping | mapping encoder: [ :priority | 'High' ] ];
				prettyPrint: true;
				nextPut: object ] ]