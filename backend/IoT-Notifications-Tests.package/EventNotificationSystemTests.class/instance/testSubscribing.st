tests
testSubscribing

	| eventsNotificationSystem |

	eventsNotificationSystem := EventNotificationSystem new.
	eventsNotificationSystem subscribe: self to: NotifiableEvent toBeNotifiedSending: #setHasBeenNotifiedToTrue.
	self assert: eventsNotificationSystem subscriptions size equals: 1