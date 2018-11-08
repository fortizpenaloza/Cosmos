Extension { #name : #DataStream }

{ #category : #'*Cosmos-Tools' }
DataStream >> gtInspectorDataPointsIn: composite [

	<gtInspectorPresentationOrder: 40>
	composite roassal2
		title: 'Graph';
		initializeView: [ RTGrapher new ];
		painting: [ :grapher | 
			| oldest dataSet average |

			oldest := dataPoints minFor: #timestamp.

			dataSet := RTData new.
			dataSet interaction popupText: [ :dataPoint | dataPoint value ].
			dataSet points: self dataPoints.
			dataSet connectColor: Color red.

			dataSet
				x: [ :dataPoint | 
					| distance |

					distance := oldest timestamp distanceTo: dataPoint timestamp.
					(distance convertTo: TimeUnits second) amount ].
			dataSet y: #value.

			average := RTAverageDecorator new.
			average withLabel: [ :aValue | 'average = ' , aValue asFloat asString ].

			grapher add: dataSet.
			grapher addDecorator: average.
			grapher extent: 400 @ 200.
			grapher axisY noDecimal.
			grapher axisX
				numberOfTicks: 4;
				labelConversion: [ :distance | 
					| label |

					label := oldest timestamp next: (TimeUnits second with: distance).
					label timeOfDay ] ]
]
