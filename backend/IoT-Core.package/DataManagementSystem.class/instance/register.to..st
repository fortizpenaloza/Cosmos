managing-private
register: aDataStream to: aFeed

	^ (aFeed dataStreams includes: aDataStream)
		ifTrue: [ ObjectAlreadyInSystem signal: 'Data stream already exists in system' ]
		ifFalse: [ aFeed add: aDataStream ]