managing-private
register: aDataChannel

	feeds
		at: aDataChannel identifier
		ifPresent: [:feed | ObjectAlreadyInSystem signal: 'Feed already exists in system']
		ifAbsent: [feeds at: aDataChannel identifier put: aDataChannel]