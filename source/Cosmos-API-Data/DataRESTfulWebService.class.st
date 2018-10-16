Class {
	#name : #DataRESTfulWebService,
	#superclass : #RESTfulWebService,
	#instVars : [
		'cosmos'
	],
	#category : #'Cosmos-API-Data'
}

{ #category : #'instance creation' }
DataRESTfulWebService class >> workingWith: aCosmosSystem [
	
	^ self new initializeWorkingWith: aCosmosSystem
]

{ #category : #API }
DataRESTfulWebService >> createBulkPointsBasedOn: anHttpRequest within: aContext [

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

{ #category : #API }
DataRESTfulWebService >> createStreamBasedOn: anHttpRequest within: aContext [

	^ [ self
		withCreatedResourceDo: [ :dataStream | self dataManagementSystem register: dataStream ]
		decodedUsing: self dataStreamsKey
		basedOn: anHttpRequest
		within: aContext ]
		on: InstanceCreationFailed
		do: [ :signal | HTTPClientError signalBadRequest: signal messageText ]
]

{ #category : #'private - accessing' }
DataRESTfulWebService >> currentDateTime [

	^ self timeSystem dateTime
]

{ #category : #'private - systems' }
DataRESTfulWebService >> dataManagementSystem [

	^ cosmos systemImplementing: #DataManagementSystemInterface
]

{ #category : #'private - object types' }
DataRESTfulWebService >> dataPointsKey [

	^ #data_points
]

{ #category : #'private - object types' }
DataRESTfulWebService >> dataStreamsKey [

	^ #data_streams
]

{ #category : #API }
DataRESTfulWebService >> deleteStreamBasedOn: anHttpRequest within: aContext [

	^ [ 
	self dataManagementSystem
		withStreamIdentifiedBy: (anHttpRequest at: #identifier)
		do: [ :dataStream | self dataManagementSystem deregister: dataStream ].

	ZnResponse noContent ]
		on: ObjectNotFound
		do: [ :signal | HTTPClientError signalNotFound: signal messageText ]
]

{ #category : #API }
DataRESTfulWebService >> getPointsBasedOn: anHttpRequest within: aContext [

	^ self
		get: [ (self dataManagementSystem streamIdentifiedBy: (anHttpRequest at: #identifier)) dataPoints ]
		encodedUsing: #data_points
		basedOn: anHttpRequest
		within: aContext
]

{ #category : #API }
DataRESTfulWebService >> getStreamsBasedOn: anHttpRequest within: aContext [

	^ [ self
		get: [ | streamsToEncode |

			self
				withIdentifierProvidedIn: anHttpRequest
				do: [ :identifier | self dataManagementSystem withStreamIdentifiedBy: identifier do: [ :dataStream | streamsToEncode := dataStream ] ]
				ifNone: [ streamsToEncode := self dataManagementSystem streams ].

			aContext hold: (cosmos systemImplementing: #MetadataSystemInterface) under: #metadata_system.
			streamsToEncode ]
		encodedUsing: #data_streams
		basedOn: anHttpRequest
		within: aContext ]
		on: DataStreamIsEmpty
		do: [ :signal | signal resume: 'N/A' ]
]

{ #category : #'private - systems' }
DataRESTfulWebService >> identifierSystem [

	^ cosmos systemImplementing: #IdentifierSystemInterface
]

{ #category : #initialization }
DataRESTfulWebService >> initializeWorkingWith: aCosmosSystem [

	cosmos := aCosmosSystem
]

{ #category : #'private - API' }
DataRESTfulWebService >> locationOf: aDataStream [

	| baseUrl |

	baseUrl := baseUrlOptional
		withContentDo: [ :theBaseUrl | theBaseUrl ]
		ifUnused: [ '' asZnUrl ].

	^ '<1p>/<2p>'
		expandMacrosWith: baseUrl / 'data-stream' asZnUrl
		with: (self identifierSystem identifierOf: aDataStream)
]

{ #category : #specification }
DataRESTfulWebService >> specification [

	^ DataRESTfulWebServiceSpecification new
]

{ #category : #'private - systems' }
DataRESTfulWebService >> timeSystem [
	
	^ cosmos systemImplementing: #TimeSystemInterface
]

{ #category : #'private - API' }
DataRESTfulWebService >> withIdentifierProvidedIn: anHttpRequest do: aBlock ifNone: ifNoneBlock [

	| identifierProvided |

	identifierProvided := true.
	anHttpRequest at: #identifier ifAbsent: [ identifierProvided := false ].

	identifierProvided
		ifTrue: [ aBlock value: (anHttpRequest at: #identifier) ]
		ifFalse: ifNoneBlock
]
