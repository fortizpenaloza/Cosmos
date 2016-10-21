as yet unclassified
testNotification
	"events notification system" 
	eventsNotificationSystem := EventNotificationSystem new.
	eventsNotificationSystem subscribe: self to: NotifiableEvent toBeNotifiedSending: #notify.

	self deny: hasBeenNotified.
	eventsNotificationSystem notify: NotifiableEvent.
	self assert: hasBeenNotified