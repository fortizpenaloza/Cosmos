tests
testRevokingSubscription

	| eventsNotificationSystem |

	eventsNotificationSystem := EventNotificationSystem new.
	eventsNotificationSystem
		subscribe: self
		to: NotifiableEvent
		toBeNotifiedSending: #setHasBeenNotifiedToTrue.
	self assert: eventsNotificationSystem subscriptions size equals: 1.

	eventsNotificationSystem revokeSubscriptionTo: NotifiableEvent of: self.
	self assert: eventsNotificationSystem subscriptions isEmpty