actions
registerDataManagementSystemInterface

	self
		registerInterfaceAs: #DataManagementSystemInterface
		named: 'Data Management System Interface'
		offering: #(#registerStreamNamed: #register:toStreamNamed: #streamNamed:ifFound:ifNone: #streams)