private-API
jsonFormattedStreams

	^ [ dataStreamsSnapshotsMapping value: self dataManagementSystem streams ]
		on: BindingNotYetDefined
		do: [ :signal | signal resume: 'N/A' ]