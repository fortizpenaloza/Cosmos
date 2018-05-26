Extension { #name : #DataStream }

{ #category : #'*Cosmos-Tools' }
DataStream >> gtInspectorDataPointsIn: composite [

	<gtInspectorPresentationOrder: 40>
	composite roassal2
		title: 'Graph';
		initializeView: [ RTGrapher new ];
		painting: [ :grapher | 
			| oldest ds |

			oldest := dataPoints minFor: #timestamp.

			ds := RTData new.
			ds dotShape color: (Color red alpha: 0.6).
			ds connectUsing: (RTLine new color: Color blue).
			ds interaction popup.
			ds points: dataPoints.
			ds x: [ :dataPoint | dataPoint timestamp timeOfDay milliseconds amount ].
			ds y: #value.

			grapher add: ds.

			grapher axisX
				title: 'time';
				labelRotation: -30;
				numberOfTicks: 10;
				numberOfLabels: 10 ]
]
