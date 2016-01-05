managing-private
register: aValue to: aDataStream of: aFeed

	aDataStream add: (DataPoint on: self timeSystem dateTime holding: aValue).

	self triggerSystem notifyDataPointRegistrationOn: aDataStream of: aFeed.
	
	self flag: 'self persistanceSystem add: (RegisteredDatapoint from: aDatapoint to: aDatastream of: aFeed)'
	