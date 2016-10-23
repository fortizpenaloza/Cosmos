tests
testNotifyingEventSendingUnaryMessage

	| eventNotificationSystem |

	eventNotificationSystem := EventNotificationSystem new.
	eventNotificationSystem notifySubscribersTo: NotifiableEvent new.
	self deny: hasBeenNotified.

	eventNotificationSystem subscribe: self to: NotifiableEvent toBeNotifiedSending: #setHasBeenNotifiedToTrue.
	self deny: hasBeenNotified.

	eventNotificationSystem notifySubscribersTo: NotifiableEvent new.
	self assert: hasBeenNotified