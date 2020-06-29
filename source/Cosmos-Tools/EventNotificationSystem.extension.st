Extension { #name : #EventNotificationSystem }

{ #category : #'*Cosmos-Tools' }
EventNotificationSystem >> gtInspectorSubscriptionsIn: aCompositePresentation [

	<gtInspectorPresentationOrder: 40>
	aCompositePresentation list
		title: [ 'Subscribers' translated ];
		display: [ subscriptions ];
		format: [ :subscription | subscription subscriber name ];
		when: [ subscriptions isNotEmpty ];
		tags: [ :subscription | subscription eventType name ]
]
