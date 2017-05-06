API
currentSnapshotOfChannelIdentifiedBy: anIdentifier

	^ self dataManagementSystem
		channelIdentifiedBy: anIdentifier asNumber
		ifFound: [ :channel | dataChannelSnapshotMapping value: (DataChannelSnapshot of: channel with: (self dataManagementSystem streamsOf: channel)) ]
		ifNone: [ ResourceNotFound signal ]