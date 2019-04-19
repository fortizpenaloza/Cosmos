Class {
	#name : #ActionEvaluationsRESTfulControllerTest,
	#superclass : #SystemBasedRESTfulControllerUserStoryTest,
	#instVars : [
		'actionEvaluationsQueue'
	],
	#category : #'Cosmos-API-Actions-Tests'
}

{ #category : #'private - accessing' }
ActionEvaluationsRESTfulControllerTest >> actionEvaluationSystem [

	^ rootSystem >> #ActionEvaluationSystemInterface
]

{ #category : #'private - accessing' }
ActionEvaluationsRESTfulControllerTest >> applicationJsonVersion1dot0dot0MediaType [

	^ resourceController specification applicationJsonVersion1dot0dot0MediaType 
]

{ #category : #'private - accessing' }
ActionEvaluationsRESTfulControllerTest >> aprilEleventh2019AtNoon [

	^ DateTime 
		date: April eleventh , 2019
		timeOfDay: TimeOfDay noon 
		zone: TimeZones buenosAires
]

{ #category : #'private - accessing' }
ActionEvaluationsRESTfulControllerTest >> baseUrl [

	^ 'https://tests.cosmos.com' asZnUrl
]

{ #category : #'tests support' }
ActionEvaluationsRESTfulControllerTest >> getDNSZones [

	^ Action
		named: 'Get DNS zones'
		sending:
			(ZnRequest new
				requestLine:
					(ZnRequestLine empty
						method: #GET;
						uri:
							'https://api.cloudflare.com/client/v4/zones/77527abc25e3d9004fd943209c925e4e/dns_records'
								asZnUrl;
						version: ZnConstants defaultHTTPVersion;
						yourself);
				headers:
					(ZnHeaders
						withAll:
							{('X-Auth-Email' -> 'patchinko@gmail.com').
							('X-Auth-Key' -> '93b0b7a99ad1fc123d0d2b6508849db7e64')}
								asDictionary);
				yourself)
]

{ #category : #running }
ActionEvaluationsRESTfulControllerTest >> setUp [

	actionEvaluationsQueue := AtomicSharedQueue new.
	super setUp
]

{ #category : #running }
ActionEvaluationsRESTfulControllerTest >> setUpRequirements [

	self
		registerSubsystem: (ActionEvaluationSystem registeringFrom: actionEvaluationsQueue)
]

{ #category : #running }
ActionEvaluationsRESTfulControllerTest >> setUpResourceController [

	resourceController := ActionEvaluationsRESTfulController workingWith: rootSystem.
]

{ #category : #tests }
ActionEvaluationsRESTfulControllerTest >> testGetActionEvaluationSummaries [

	| response |

	self actionEvaluationSystem
		register:
			(ActionEvaluation
				of: self getDNSZones
				on: self aprilEleventh2019AtNoon).

	response := resourceController
		getActionEvaluationSummariesBasedOn:
			(self
				requestToGetResourcesAccepting: self applicationJsonVersion1dot0dot0MediaType)
		within: self httpRequestContext.

	self
		deny: self actionEvaluationSystem actionEvaluationSummaries isEmpty.
	self
		assert: response code equals: 200;
		assert: response contents
			equals:
			'[{"action":{"name":"Get DNS zones"},"lastEvaluation":"2019-04-11T12:00:00-03:00","evaluationCount":1}]'
]

{ #category : #tests }
ActionEvaluationsRESTfulControllerTest >> testGetActionEvaluationSummariesEmpty [

	| response |

	response := resourceController
		getActionEvaluationSummariesBasedOn:
			(self
				requestToGetResourcesAccepting: self applicationJsonVersion1dot0dot0MediaType)
		within: self httpRequestContext.

	self
		assert: response code equals: 200;
		assert: response contents equals: '[]'
]

{ #category : #tests }
ActionEvaluationsRESTfulControllerTest >> testGetActionEvaluations [

	| response |

	self actionEvaluationSystem
		register:
			(ActionEvaluation
				of: self getDNSZones
				on: self aprilEleventh2019AtNoon).

	response := resourceController
		getActionEvaluationsBasedOn:
			(self
				requestToGetResourcesAccepting: self applicationJsonVersion1dot0dot0MediaType)
		within: self httpRequestContext.

	self
		deny: self actionEvaluationSystem actionEvaluationSummaries isEmpty.
	self
		assert: response code equals: 200;
		assert: response contents
			equals:
			'[{"action":{"name":"Get DNS zones"},"evaluationDateTime":"2019-04-11T12:00:00-03:00"}]'
]

{ #category : #tests }
ActionEvaluationsRESTfulControllerTest >> testGetActionEvaluationsEmpty [

	| response |

	response := resourceController
		getActionEvaluationsBasedOn:
			(self
				requestToGetResourcesAccepting: self applicationJsonVersion1dot0dot0MediaType)
		within: self httpRequestContext.

	self
		assert: response code equals: 200;
		assert: response contents equals: '[]'
]
