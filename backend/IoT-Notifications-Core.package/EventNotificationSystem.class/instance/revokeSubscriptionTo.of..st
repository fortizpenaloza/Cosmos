subscribing
revokeSubscriptionTo: anEventType of: aSubjectOfInterest

	subscriptions
		detect: [ :subscription | 
			subscription subject = aSubjectOfInterest
				and: [ subscription eventType = anEventType ] ]
		ifFound: [ :foundSubscription | subscriptions remove: foundSubscription ]
		ifNone: [ ObjectNotFoundInSystem signal: 'lala' ]