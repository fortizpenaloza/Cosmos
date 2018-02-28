API
streams

	^ ZnResponse ok:
		(ZnEntity json: self jsonFormattedStreams)