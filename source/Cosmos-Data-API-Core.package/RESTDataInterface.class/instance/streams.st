API
streams

	^ [ ZnResponse
		ok: (ZnEntity json: (dataChannelSnapshotMapping value: self dataManagementSystem streams)) ]
		on: BindingNotYetDefined
		do: [ :signal | signal resume: 'N/A' ]