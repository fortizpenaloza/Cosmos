tests
testNotifyingEventSendingKeyworkMessage

	| eventNotificationSystem |

	eventNotificationSystem := EventNotificationSystem new.
	eventNotificationSystem
		subscribe: self
		to: TestEvent
		toBeNotifiedSending: #setHasBeenNotifiedUsing:.
	self deny: hasBeenNotified.
	
	eventNotificationSystem notifySubscribersTo: TestEvent new.
	self assert: hasBeenNotified