querying
streamsOf: aDataChannel

	^ dataStreams select: [ :dataStream | dataStream dataChannel = aDataChannel ]