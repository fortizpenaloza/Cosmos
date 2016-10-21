subscribing-private
assertNotAlreadyExists: aSubjectOfInterest subscribedTo: anEventType

	subscriptions
		detect: [ :subscription | 
			subscription subject = aSubjectOfInterest
				and: [ subscription eventType = anEventType ] ]
		ifFound: [ ObjectAlreadyInSystem
				signal: 'Object already subscribed to this event type.' ]