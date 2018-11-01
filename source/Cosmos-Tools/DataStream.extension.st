Extension { #name : #DataStream }

{ #category : #'*Cosmos-Tools' }
DataStream >> gtInspectorDataPointsIn: composite [

	<gtInspectorPresentationOrder: 40>
	composite roassal2
		title: 'Graph';
		initializeView: [ RTGrapher new ];
		painting: [ :grapher | 
			| oldest dataSet deviation average |

			oldest := dataPoints minFor: #timestamp.

			dataSet := RTData new.
			dataSet interaction popupText: [ :dataPoint | dataPoint value ].
			dataSet points: self dataPoints.

			dataSet
				x: [ :dataPoint | 
					| distance |

					distance := oldest timestamp distanceTo: dataPoint timestamp.
					(distance convertTo: TimeUnits second) amount ].
			dataSet y: #value.

			deviation := RTDevVarDecorator new.
			deviation
				moveBehind;
				deviation: 0.5;
				color: (Color blue alpha: 0.3);
				points: (self dataPoints collect: #value).

			average := RTAverageDecorator new.
			average
				withLabel: [ :aValue | 'average = ' , aValue asFloat asString ].

			grapher add: dataSet.
			grapher addDecorator: deviation.
			grapher addDecorator: average.

			grapher axisY noDecimal.
			grapher axisX
				numberOfTicks: 2;
				labelConversion: [ :distance | 
					| label |

					label := oldest timestamp next: (TimeUnits second with: distance).
					label timeOfDay ] ]
]
