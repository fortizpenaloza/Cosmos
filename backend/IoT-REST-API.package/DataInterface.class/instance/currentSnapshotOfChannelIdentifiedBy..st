API
currentSnapshotOfChannelIdentifiedBy: anIdentifier

	^ self dataManagementSystem
		channelIdentifiedBy: anIdentifier asNumber
		ifFound: [ :channel | 
			jsonMapping
				value:
					(DataChannelSnapshot
						of: channel
						with: (self dataStreamSnapshotsOf: channel)) ]
		ifNone: [ ResourceNotFound signal ]