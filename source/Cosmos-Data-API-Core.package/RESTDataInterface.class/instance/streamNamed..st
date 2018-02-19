API
streamNamed: aName

	^ [ ZnResponse
		ok:
			(ZnEntity
				json:
					(self dataManagementSystem
						streamNamed: aName
						ifFound: [ :stream | dataStreamMapping value: stream ]
						ifNone: [ HTTPClientError signalNotFound ])) ]
		on: BindingNotYetDefined
		do: [ :signal | signal resume: 'N/A' ]