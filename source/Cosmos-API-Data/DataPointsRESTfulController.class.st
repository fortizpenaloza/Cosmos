Class {
	#name : #DataPointsRESTfulController,
	#superclass : #ResourceRESTfulController,
	#instVars : [
		'cosmos'
	],
	#category : #'Cosmos-API-Data'
}

{ #category : #'instance creation' }
DataPointsRESTfulController class >> workingWith: aCosmosSystem [
	
	^ self new initializeWorkingWith: aCosmosSystem
]

{ #category : #API }
DataPointsRESTfulController >> createPointsBasedOn: anHttpRequest within: aContext [

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
DataPointsRESTfulController >> currentDateTime [

	^ self timeSystem dateTime
]

{ #category : #'private - systems' }
DataPointsRESTfulController >> dataManagementSystem [

	^ cosmos systemImplementing: #DataManagementSystemInterface
]

{ #category : #'private - object types' }
DataPointsRESTfulController >> dataPointsKey [

	^ #data_points
]

{ #category : #initialization }
DataPointsRESTfulController >> initializeWorkingWith: aCosmosSystem [

	cosmos := aCosmosSystem
]

{ #category : #specification }
DataPointsRESTfulController >> specification [

	^ DataPointsRESTfulControllerSpecification new
]

{ #category : #'private - systems' }
DataPointsRESTfulController >> timeSystem [
	
	^ cosmos systemImplementing: #TimeSystemInterface
]
