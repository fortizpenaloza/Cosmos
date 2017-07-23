API
registerStreamNamed: aName

	^ [ self dataManagementSystem registerStreamNamed: aName ]
		on: ObjectAlreadyInSystem
		do: [ :signal | HTTPClientError signalConflict: signal messageText ]