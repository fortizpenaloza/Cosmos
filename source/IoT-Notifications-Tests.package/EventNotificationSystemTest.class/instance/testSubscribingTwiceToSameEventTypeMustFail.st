tests
testSubscribingTwiceToSameEventTypeMustFail

	| eventsNotificationSystem |

	eventsNotificationSystem := EventNotificationSystem new.
	eventsNotificationSystem
		subscribe: self
		to: NotifiableEvent
		toBeNotifiedSending: #setHasBeenNotifiedToTrue.

	self
		should: [ eventsNotificationSystem
				subscribe: self
				to: NotifiableEvent
				toBeNotifiedSending: #setHasBeenNotifiedToTrue ]
		raise: ObjectAlreadyInSystem