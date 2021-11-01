Extension { #name : #CompositeSystem }

{ #category : #'*Cosmos-Tools' }
CompositeSystem >> inspectSubsystems [

	<inspectorPresentationOrder: 40 title: 'Subsystems'>
	^ SpTablePresenter new
		items: subsystems;
		addColumn: (SpStringTableColumn 
			title: 'Name' 
			evaluated: [ :subsystem | subsystem name ]);
		addColumn: (SpStringTableColumn 
			title: 'Implemented interfaces'
			evaluated: [ :subsystem | subsystem implementedInterfaces]);
		yourself.
]
