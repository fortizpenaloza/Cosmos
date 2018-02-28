API
registerFrom: aJSON

	^ [ [ | rawTrigger |

	rawTrigger := (NeoJSONReader on: aJSON readStream)
		propertyNamesAsSymbols: true;
		next.

	self triggerManagementSystem
		registerNamed: (rawTrigger at: #name)
		triggering: (context  parseActionFrom: rawTrigger) 
		accordingTo: (context parseTriggeringPolicyFrom: rawTrigger) 
		whenMeets: (context parseConditionFrom: rawTrigger).

	ZnResponse created: (ZnUrl fromString: 'localhost') ]
		on: ObjectAlreadyInSystem
		do: [ :signal | HTTPClientError signalConflict: signal messageText ] ]
		on: KeyNotFound , ParsingFailed 
		do: [ :signal | 
			HTTPClientError
				signalBadRequest:
					('{"error":{"code":400,"message":"Expected key <1s> was not found"}'
						expandMacrosWith: signal key) ]