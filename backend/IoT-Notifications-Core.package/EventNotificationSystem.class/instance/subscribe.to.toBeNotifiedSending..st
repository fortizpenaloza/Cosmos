subscribing
subscribe: aSubjectOfInterest to: anEventType toBeNotifiedSending: aMessage

	self assertNotAlreadyExists: aSubjectOfInterest subscribedTo: anEventType. 

	subscriptions
		add: (Subscription of: aSubjectOfInterest to: anEventType toBeNotifiedSending: aMessage)