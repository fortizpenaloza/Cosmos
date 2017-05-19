initialization
initializeMappings

	prioritizedCommandtMapping := [ :object | 
	String
		streamContents: [ :stream | 
			(NeoJSONWriter on: stream)
				for: PrioritizedCommand
					do: [ :mapping | 
					mapping
						mapAccessor: #command;
						mapAccessor: #priorityLabel to: #priority];
				prettyPrint: true;
				nextPut: object ] ]
