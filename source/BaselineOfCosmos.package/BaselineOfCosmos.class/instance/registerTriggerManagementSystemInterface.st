actions
registerTriggerManagementSystemInterface

	self
		registerInterfaceAs: #TriggerManagementSystemInterface
		named: 'Trigger Management System Interface'
		declaring: #(#registerNamed:triggering:afterDataPointWasRegisteredOn:ifSatisfies: #registerNamed:triggering:periodicallyEvery:ifSatisfies: #deregisterNamed: #havePassed: #dataPointRegisteredOn: #triggers)