API
streams

	^ [ TeaResponse ok
		body: (ZnEntity json: (dataChannelSnapshotMapping value: self dataManagementSystem streams)) ]
		on: BindingNotYetDefined
		do: [ :signal | signal resume: 'N/A' ]