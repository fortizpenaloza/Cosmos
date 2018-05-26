actions
registerDataManagementSystemInterface

	self
		registerInterfaceAs: #DataManagementSystemInterface
		named: 'Data Management System Interface'
		declaring: #(#registerStreamNamed: #register:toStreamNamed: #streamNamed:ifFound:ifNone: #streams)