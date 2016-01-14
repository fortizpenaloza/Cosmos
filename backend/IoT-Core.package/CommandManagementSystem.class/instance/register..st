managing
register: aCommandQueue 

	commandQueues at: aCommandQueue identifier
		ifPresent: [:feed | ObjectAlreadyInSystem signal: 'Command queue already exists in system.']
		ifAbsent: [commandQueues at: aCommandQueue identifier put: aCommandQueue] 