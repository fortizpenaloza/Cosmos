API support
dataStreamSnapshotsOf: channel

	^ (self dataManagementSystem streamsOf: channel)
		collect: [ :dataStream | 
			DataStreamSnapshot
				named: dataStream name
				updatedOn: dataStream lastUpdate
				with:  dataStream currentValue ]