actions
registerTriggerManagementSystemInterface

	self
		registerInterfaceAs: #TriggerManagementSystemInterface
		named: 'Trigger Management System Interface'
		offering: #(#registerNamed:triggering:afterDataPointWasRegisteredOn:ifSatisfies: #registerNamed:triggering:periodicallyEvery:ifSatisfies: #deregisterNamed: #havePassed: #dataPointRegisteredOn: #triggers)