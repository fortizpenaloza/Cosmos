managing-private
register: aCommandQueue

	self
		queueIdentifiedBy: aCommandQueue identifier
		ifFound: [ :commandQueue | ObjectAlreadyInSystem signal: 'Command priority queue already exists in system.' ]
		ifNone: [ commandPriorityQueues at: aCommandQueue identifier put: aCommandQueue ]