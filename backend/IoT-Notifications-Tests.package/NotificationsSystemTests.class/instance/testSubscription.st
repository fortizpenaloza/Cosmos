as yet unclassified
testSubscription

	eventsNotificationSystem := EventNotificationSystem new.
	eventsNotificationSystem subscribe: self to: NotifiableEvent toBeNotifiedSending: #notify.

	self assert: eventsNotificationSystem subscriptions size equals: 1