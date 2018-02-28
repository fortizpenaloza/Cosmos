private-API
jsonFormattedStreamNamed: aName

	^ [ self dataManagementSystem
		streamNamed: aName
		ifFound: [ :dataStream | dataStreamMapping value: dataStream ]
		ifNone: [ HTTPClientError signalNotFound ] ]
			on: BindingNotYetDefined
			do: [ :signal | signal resume: 'N/A' ]