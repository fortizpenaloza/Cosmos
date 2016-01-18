managing
register: aFeed

	feeds
		at: aFeed identifier
		ifPresent: [:feed | ObjectAlreadyInSystem signal: 'Feed already exists in system']
		ifAbsent: [feeds at: aFeed identifier put: aFeed]