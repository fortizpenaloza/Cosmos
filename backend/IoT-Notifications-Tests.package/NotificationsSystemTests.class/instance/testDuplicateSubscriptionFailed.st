as yet unclassified
testDuplicateSubscriptionFailed

	eventsNotificationSystem := EventNotificationSystem new.
	eventsNotificationSystem subscribe: self to: NotifiableEvent toBeNotifiedSending: #notify.
	
	self should: [ eventsNotificationSystem subscribe: self to: NotifiableEvent toBeNotifiedSending: #notify ] raise: ObjectAlreadyInSystem 