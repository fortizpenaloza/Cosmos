Extension { #name : #EventNotificationSystem }

{ #category : #'*Cosmos-Tools' }
EventNotificationSystem >> inspectSubscriptions [

	<inspectorPresentationOrder: 40 title: 'Subscriptions'>
	^ SpTablePresenter new
		items: subscriptions;
		addColumn: (SpStringTableColumn 
			title: 'Subscriber' 
			evaluated: [ :subscription | subscription subscriber name ]);
		addColumn: (SpStringTableColumn 
			title: 'Event type'
			evaluated: [ :subscription | subscription eventType name]);
		yourself.
]
