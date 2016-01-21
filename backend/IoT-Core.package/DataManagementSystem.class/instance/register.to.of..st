managing-private
register: aValue to: aDataStream of: aFeed

	aDataStream add: (DataPoint on: self timeSystem dateTime holding: aValue).

	self conditionalTriggerManagementSystem notifyDataPointRegistrationOn: aDataStream of: aFeed.
	