Class {
	#name : #ActionEvaluationSummariesRESTfulControllerTest,
	#superclass : #SystemBasedRESTfulControllerUserStoryTest,
	#category : #'Cosmos-API-Actions-Tests'
}

{ #category : #accessing }
ActionEvaluationSummariesRESTfulControllerTest >> applicationJsonVersion1dot0dot0MediaType [

	^ resourceController specification applicationJsonVersion1dot0dot0MediaType 
]

{ #category : #accessing }
ActionEvaluationSummariesRESTfulControllerTest >> aprilEleventh2019AtNoon [

	^ DateTime 
		date: April eleventh , 2019
		timeOfDay: TimeOfDay noon 
		zone: TimeZones buenosAires
]

{ #category : #'private - accessing' }
ActionEvaluationSummariesRESTfulControllerTest >> baseUrl [

	^ 'https://tests.cosmos.com' asZnUrl
]

{ #category : #'tests support' }
ActionEvaluationSummariesRESTfulControllerTest >> registerGetDNSZones [

	| action |

	action := Action
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
				yourself).

	self actionManagementSystem register: action
]

{ #category : #running }
ActionEvaluationSummariesRESTfulControllerTest >> setUpRequirements [

	self flag: 'requireActionManagementSystem'.
	
	self
		registerSubsystem: (TimeSystem using: (FixedTimeSource on: self systemDateTime));
		registerSubsystem: EventNotificationSystem new;
		registerSubsystem: MetadataSystem new;
		registerSubsystem: TimestampingSystem new;
		registerSubsystem: (IdentifierSystem using: self identifierProvider);
		registerSubsystem: ActionManagementSystem new
]

{ #category : #running }
ActionEvaluationSummariesRESTfulControllerTest >> setUpResourceController [

	resourceController := ActionEvaluationSummariesRESTfulController workingWith: rootSystem.
]

{ #category : #accessing }
ActionEvaluationSummariesRESTfulControllerTest >> systemDateTime [

	^ DateTime 
		date: October first , 2014 
		timeOfDay: TimeOfDay noon 
		zone: TimeZones buenosAires
]

{ #category : #tests }
ActionEvaluationSummariesRESTfulControllerTest >> testGetActionEvaluationSummaries [

	| response |

	self registerGetDNSZones.

	self actionManagementSystem
		handleActionEvaluatedOn:
			(ActionEvaluation
				of: self actionManagementSystem actions first
				on: self aprilEleventh2019AtNoon).

	response := resourceController
		getActionEvaluationSummariesBasedOn:
			(self
				requestToGetResourcesAccepting: self applicationJsonVersion1dot0dot0MediaType)
		within: self httpRequestContext.

	self
		deny: self actionManagementSystem actionEvaluationSummaries isEmpty.
	self
		assert: response code equals: 200;
		assert: response contents
			equals:
			'[{"action":{"name":"Get DNS zones"},"lastEvaluation":"2019-04-11T12:00:00-03:00","evaluationCount":1}]'
]

{ #category : #tests }
ActionEvaluationSummariesRESTfulControllerTest >> testGetActionEvaluationSummariesEmpty [

	| response |

	self registerGetDNSZones.

	response := resourceController
		getActionEvaluationSummariesBasedOn:
			(self
				requestToGetResourcesAccepting: self applicationJsonVersion1dot0dot0MediaType)
		within: self httpRequestContext.

	self
		assert: response code equals: 200;
		assert: response contents equals: '[]'
]
