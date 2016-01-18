managing
register: aValue to: aDataStream of: aFeed

	aDataStream add: (DataPoint on: timeSystem dateTime holding: aValue).

	conditionalTriggerManagementSystem notifyDataPointRegistrationOn: aDataStream of: aFeed.
	