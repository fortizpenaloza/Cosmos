Class {
	#name : #DataPointsRESTfulWebService,
	#superclass : #RESTfulWebService,
	#instVars : [
		'cosmos'
	],
	#category : #'Cosmos-API-Data'
}

{ #category : #'instance creation' }
DataPointsRESTfulWebService class >> workingWith: aCosmosSystem [
	
	^ self new initializeWorkingWith: aCosmosSystem
]

{ #category : #API }
DataPointsRESTfulWebService >> createPointsBasedOn: anHttpRequest within: aContext [

	^ [ | rawData |

	aContext hold: self currentDateTime under: #request_timestamp.

	rawData := self
		decode: anHttpRequest contents
		at: self dataPointsKey
		from: anHttpRequest contentType
		within: aContext.

	rawData
		do: [ :rawDataPoint | 
			self dataManagementSystem
				register: rawDataPoint value
				toStreamNamed: rawDataPoint key ].

	ZnResponse created: 'multiple' ]
		on: ObjectNotFound
		do:
			[ :signal | HTTPClientError signalBadRequest: signal messageText ]
]

{ #category : #'private - accessing' }
DataPointsRESTfulWebService >> currentDateTime [

	^ self timeSystem dateTime
]

{ #category : #'private - systems' }
DataPointsRESTfulWebService >> dataManagementSystem [

	^ cosmos systemImplementing: #DataManagementSystemInterface
]

{ #category : #'private - object types' }
DataPointsRESTfulWebService >> dataPointsKey [

	^ #data_points
]

{ #category : #initialization }
DataPointsRESTfulWebService >> initializeWorkingWith: aCosmosSystem [

	cosmos := aCosmosSystem
]

{ #category : #specification }
DataPointsRESTfulWebService >> specification [

	^ DataPointsRESTFulWebServiceSpecification new
]

{ #category : #'private - systems' }
DataPointsRESTfulWebService >> timeSystem [
	
	^ cosmos systemImplementing: #TimeSystemInterface
]
