managing-private
registerPoint: aDataPoint to: aDataStream

	aDataStream add: aDataPoint.

	eventNotificationSystem
		notifySubscribersTo: (DataPointRegistrationEvent on: aDataStream)