notifying
notify: anEventType

	subscriptions
		select: [ :subscription | subscription eventType = anEventType ]
		thenDo:
			[ :filteredSubscription | filteredSubscription subject perform: filteredSubscription message ]