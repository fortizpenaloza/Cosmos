initialize-release
initializeWorkingWith: aCompositeSystem

	rootSystem := aCompositeSystem.
	jsonMapping := [ :object | 
	String
		streamContents: [ :stream | 
			(NeoJSONWriter on: stream)
				for: DataChannelSnapshot do: [ :mapping | mapping mapAccessors: #(#name #dataStreams) ];
				for: DataStreamSnapshot
					do: [ :mapping | 
					mapping
						mapInstVar: #name to: 'name';
						mapInstVar: #value to: 'currentValue';
						mapInstVar: #timestamp to: 'lastUpdate' ];
				for: DataStream
					do: [ :mapping | 
					mapping
						mapAccessors: #(#name #currentValue #lastUpdate);
						mapAccessor: #dataPoints to: 'data points' ];
				for: DataPoint
					do: [ :mapping | 
					mapping
						mapAccessor: #timestamp;
						mapAccessor: #value ];
				for: DateTime customDo: [ :mapping | mapping encoder: [ :dateTime | dateTime printString ] ];
				prettyPrint: true;
				nextPut: object ] ]