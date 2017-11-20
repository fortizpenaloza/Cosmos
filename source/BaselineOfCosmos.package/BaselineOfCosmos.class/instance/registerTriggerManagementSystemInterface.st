actions
registerTriggerManagementSystemInterface

	self
		registerInterfaceAs: #TriggerManagementSystemInterface
		named: 'Trigger Management System Interface'
		offering: #(#registerNamed:triggering:afterDataPointWasRegisteredOn:whenMeets: #registerNamed:triggering:periodicallyEvery:whenMeets: #deregisterNamed: #havePassed: #dataPointRegisteredOn: #triggers)