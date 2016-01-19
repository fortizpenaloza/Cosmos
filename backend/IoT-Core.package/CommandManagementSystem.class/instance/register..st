managing
register: aCommandPriorityQueue

	priorityCommandQueues
		at: aCommandPriorityQueue identifier
		ifPresent:
			[ :commandPriorityQueue | ObjectAlreadyInSystem signal: 'Command queue already exists in system.' ]
		ifAbsent:
			[ priorityCommandQueues at: aCommandPriorityQueue identifier put: aCommandPriorityQueue ]