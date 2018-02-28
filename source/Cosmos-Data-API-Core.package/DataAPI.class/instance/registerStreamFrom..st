API
registerStreamFrom: aJSON

	^ [ [ | rawStream name |

	rawStream := (NeoJSONReader on: aJSON readStream)
		propertyNamesAsSymbols: true;
		next.
		
	name := rawStream at: #name.

	self dataManagementSystem registerStreamNamed: name.
	ZnResponse created: (ZnUrl fromString: 'localhost') ]
		on: ObjectAlreadyInSystem
		do: [ :signal | HTTPClientError signalConflict: signal messageText ] ]
		on: KeyNotFound
		do: [ :signal | HTTPClientError signalBadRequest: signal messageText ]