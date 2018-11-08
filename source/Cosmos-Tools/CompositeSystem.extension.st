Extension { #name : #CompositeSystem }

{ #category : #'*Cosmos-Tools' }
CompositeSystem >> gtInspectorSystemsIn: aCompositePresentation [

	<gtInspectorPresentationOrder: 40>
	aCompositePresentation list
		title: [ 'Systems' translated ];
		display: [ systems ];
		when: [ systems isNotEmpty ];
		tags: [ :system | system class implementedInterface printString ]
]
