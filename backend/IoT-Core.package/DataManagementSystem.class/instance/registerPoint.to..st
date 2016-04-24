managing-private
registerPoint: aDataPoint to: aDataStream

	aDataStream add: aDataPoint.

	conditionalTriggerManagementSystem notifyDataPointRegistrationOn: aDataStream