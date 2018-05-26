API
streamNamed: aName

	^ ZnResponse
		ok: (ZnEntity json: (self jsonFormattedStreamNamed: aName))