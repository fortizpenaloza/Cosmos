pushing-popping
push: aJSON

	| rawCommand |

	rawCommand := (NeoJSONReader on: aJSON readStream)
		propertyNamesAsSymbols: true;
		next.

	^ self commandManagementSystem
		enqueue: (rawCommand at: #command)
		with: (self parse: (rawCommand at: #priority) with: self priorityParser)