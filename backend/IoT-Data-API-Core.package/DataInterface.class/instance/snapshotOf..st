API support
snapshotOf: aChannel

	^ DataChannelSnapshot
		of: aChannel
		with: (self dataManagementSystem streamsOf: aChannel)