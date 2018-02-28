API
registerBulkPointsFrom: aJSON

	^ [ | rawData |

	rawData := (NeoJSONReader on: aJSON readStream)
		propertyNamesAsSymbols: true;
		next.

	rawData
		do:
			[ :rawDataPoint | self register: (rawDataPoint at: 'value') toStreamNamed: (rawDataPoint at: 'data-stream') ].

	ZnResponse created: 'all' ]
		on: KeyNotFound
		do: [ :signal | 
			HTTPClientError
				signalBadRequest:
					('{"error":{"code":400,"message":"Expected key <1s> was not found"}'
						expandMacrosWith: signal key) ]