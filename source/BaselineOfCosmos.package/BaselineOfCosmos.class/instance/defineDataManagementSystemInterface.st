actions
defineDataManagementSystemInterface

	Smalltalk
		at: #DataManagementSystemInterface
		put:
			(SystemInterface
				named: 'Data Management System Interface'
				offering:
					#(#registerStreamNamed: #register:toStreamNamed: #streamNamed:ifFound:ifNone: #streams))