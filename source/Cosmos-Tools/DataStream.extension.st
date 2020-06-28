Extension { #name : #DataStream }

{ #category : #'*Cosmos-Tools' }
DataStream >> gtInspectorDataPointsIn: composite [

	<gtInspectorPresentationOrder: 40>
	composite roassal3
		title: [ 'Chart' ];
		initializeCanvas: [ | x y chart |

			y := dataPoints collect: #value.
			x := dataPoints
				collect:
					[ :dataPoint | ( ( dataPoint timestamp absoluteDistanceTo: self unixTime ) convertTo: TimeUnits second ) amount ].

			chart := RSChart new
				addPlot: ( RSLinePlot new x: x y: y );
				ylabel: 'value';
				xlabel: 'time';
				addDecoration: RSVerticalTick new;
				build.

			chart canvas
			]
]

{ #category : #'*Cosmos-Tools' }
DataStream >> unixTime [

	^ ( January first , 1970 ) atMidnight
]
