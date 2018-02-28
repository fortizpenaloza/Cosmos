API
registerFrom: aJSON

	^ [ [ | rawAction |

	rawAction := (NeoJSONReader on: aJSON readStream)
		propertyNamesAsSymbols: true;
		next.

	self actionManagementSystem
		registerNamed: (context parseNameFrom: rawAction)
		toEvaluate: (context parseRequestFrom: rawAction).

	ZnResponse created: (ZnUrl fromString: 'localhost') ]
		on: ObjectAlreadyInSystem
		do: [ :signal | 
			HTTPClientError
				signalConflict: ('{"error":{"code": 409,"message":"<1s>"}}' expandMacrosWith: signal messageText) ] ]
		on: KeyNotFound , ParsingFailed
		do: [ :signal | 
			HTTPClientError
				signalBadRequest:
					('{"error":{"code":400,"message":"Expected key <1s> was not found"}'
						expandMacrosWith: signal key) ]