API
currentSnapshotOfChannelIdentifiedBy: anIdentifier

	^ self dataManagementSystem
		channelIdentifiedBy: anIdentifier asNumber
		ifFound: [ :channel | dataChannelSnapshotMapping value: (self snapshotOf: channel) ]
		ifNone: [ HTTPClientError signalNotFound ]