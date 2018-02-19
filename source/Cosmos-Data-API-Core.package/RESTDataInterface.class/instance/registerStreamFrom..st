API
registerStreamFrom: aJSON

	^ [ [ | name |

	name := (STONJSON fromString: aJSON) at: #name.
	self dataManagementSystem registerStreamNamed: name.
	ZnResponse created: (ZnUrl fromString: 'localhost') ]
		on: ObjectAlreadyInSystem
		do: [ :signal | HTTPClientError signalConflict: signal messageText ] ]
		on: KeyNotFound
		do: [ :signal | HTTPClientError signalBadRequest: signal messageText ]