tests
testAnAPIRestImplementationCanAnswerToQuery

	| teapot |
	teapot := Teapot
		configure:
			{(#port -> 8010).
			(#debugMode -> true)}.
	teapot
		GET:
			'/dataChannel/<dataChannelId>/dataStream/<dataStreamName>'
				-> [ :request | 
					self dataManagementSystem
						streamNamed: (request at: #dataStreamName)
						ofChannelIdentifiedBy: (request at: #dataChannelId) asNumber
						ifFound: [ :dataStreamFound | 
							self
								assert: dataStreamFound name equals: 'Temperature';
								assert: dataStreamFound creationDateTime equals: self timeSystem dateTime;
								withTheOnlyOneIn: dataStreamFound dataPoints
									do: [ :dataPoint | 
									self assert: dataPoint value equals: 16.
									self assert: dataPoint timestamp equals: self timeSystem dateTime ] ]
						ifNone: [  ] ];
		start.
	ZnEasy
		get:
			'http://localhost:8010/dataChannel/' , self identifier asString , '/dataStream/'
				, 'Temperature'. "dataStream name."
	teapot stop