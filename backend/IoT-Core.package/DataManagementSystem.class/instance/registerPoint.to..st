managing-private
registerPoint: aDataPoint to: dataStream

	dataStream add: aDataPoint.
	
	conditionalTriggerManagementSystem notifyDataPointRegistrationOn: dataStream of: dataStream 