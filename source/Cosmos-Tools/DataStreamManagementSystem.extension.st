Extension { #name : #DataStreamManagementSystem }

{ #category : #'*Cosmos-Tools' }
DataStreamManagementSystem >> inspectDataStreams [

	<inspectorPresentationOrder: 40 title: 'Data Streams'>
	^ SpTablePresenter new
		  items: dataStreams;
		  addColumn: ( SpStringTableColumn title: 'Name' evaluated: #name );
		  addColumn: ( SpStringTableColumn title: 'Current value' evaluated: [ :dataStream | 
					    [ dataStream currentValue ] on: DataStreamIsEmpty
						    do: [ :signal | signal return: 'N/A' ]
					    ] );
		  addColumn: ( SpStringTableColumn title: 'Last update' evaluated: [ :dataStream | 
					    [ dataStream lastUpdate ] on: DataStreamIsEmpty
						    do: [ :signal | signal return: 'N/A' ]
					    ] );
		  addColumn: ( SpStringTableColumn title: 'Last update' evaluated: [ :dataStream | 
					    [ dataStream lastUpdate ] on: DataStreamIsEmpty
						    do: [ :signal | signal return: 'N/A' ]
					    ] );
		  yourself
]
