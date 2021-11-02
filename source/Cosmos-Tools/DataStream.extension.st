Extension { #name : #DataStream }

{ #category : #'*Cosmos-Tools' }
DataStream >> inspectionDataPoints [

	<inspectorPresentationOrder: 40 title: 'Chart'>
	| x y chart |

	x := dataPoints collect: [ :dataPoint | 
		     ( ( dataPoint timestamp absoluteDistanceTo: self unixTime ) convertTo: TimeUnits second )
			     amount ].

	y := dataPoints collect: #value.

	chart := RSChart new
		         addPlot: ( RSLinePlot new x: x y: y );
		         ylabel: 'value';
		         xlabel: 'time';
		         addDecoration: RSVerticalTick new;
		         build.

	^ SpRoassal3InspectorPresenter new
		  canvas: chart canvas;
		  yourself
]

{ #category : #'*Cosmos-Tools' }
DataStream >> unixTime [

	^ ( January first , 1970 ) atMidnight
]
