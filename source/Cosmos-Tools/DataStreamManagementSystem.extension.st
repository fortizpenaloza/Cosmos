Extension { #name : #DataStreamManagementSystem }

{ #category : #'*Cosmos-Tools' }
DataStreamManagementSystem >> gtInspectorDataStreamsIn: aCompositePresentation [

	<gtInspectorPresentationOrder: 5>
	aCompositePresentation table
		title: [ 'Data streams' translated ];
		display: [ dataStreams ];
		when: [ dataStreams isNotEmpty ];
		column: 'Name' translated evaluated: #name;
		column: 'Current value' translated
			evaluated: [ :dataStream | 
			[ dataStream currentValue ]
				on: DataStreamIsEmpty
				do: [ :signal | signal return: 'N/A' ] ];
		column: 'Last update' translated
			evaluated: [ :dataStream | 
			[ dataStream lastUpdate ]
				on: DataStreamIsEmpty
				do: [ :signal | signal return: 'N/A' ] ]
]
