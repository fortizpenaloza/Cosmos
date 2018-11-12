Class {
	#name : #DataStreamsRESTfulController,
	#superclass : #ResourceRESTfulController,
	#instVars : [
		'cosmos'
	],
	#category : #'Cosmos-API-Data'
}

{ #category : #'instance creation' }
DataStreamsRESTfulController class >> workingWith: aCosmosSystem [
	
	^ self new initializeWorkingWith: aCosmosSystem
]

{ #category : #API }
DataStreamsRESTfulController >> createStreamBasedOn: anHttpRequest within: aContext [

	^ [ self
		withCreatedResourceDo: [ :dataStream | self dataManagementSystem register: dataStream ]
		decodedUsing: self dataStreamsKey
		basedOn: anHttpRequest
		within: aContext ]
		on: InstanceCreationFailed
		do: [ :signal | HTTPClientError signalBadRequest: signal messageText ]
]

{ #category : #'private - systems' }
DataStreamsRESTfulController >> dataManagementSystem [

	^ cosmos systemImplementing: #DataManagementSystemInterface
]

{ #category : #'private - object types' }
DataStreamsRESTfulController >> dataStreamsKey [

	^ #data_streams
]

{ #category : #API }
DataStreamsRESTfulController >> deleteStreamBasedOn: anHttpRequest within: aContext [

	^ [ self
		withStreamRequestedIn: anHttpRequest
		do: [ :dataStream | self dataManagementSystem deregister: dataStream ].

	ZnResponse noContent ]
		on: ObjectNotFound
		do: [ :signal | HTTPClientError signalNotFound: signal messageText ]
]

{ #category : #API }
DataStreamsRESTfulController >> getPointsBasedOn: anHttpRequest within: aContext [

	| mediaType resourceCollection encodedResourceCollection |

	mediaType := self targetMediaTypeFrom: anHttpRequest.
		resourceCollection := self
		evaluateQuery: [ (self dataManagementSystem
				streamIdentifiedBy: (anHttpRequest at: #identifier)) dataPoints ].

	encodedResourceCollection := self
		encode: resourceCollection
		at: #data_points
		to: mediaType
		within: aContext.
		
	^ ZnResponse ok: encodedResourceCollection 
]

{ #category : #API }
DataStreamsRESTfulController >> getStreamBasedOn: anHttpRequest within: aContext [

	^ [ self
			get: [ 
				aContext hold: self metadataSystem under: #metadata_system.
				self streamRequestedIn: anHttpRequest ]
			encodedUsing: #data_streams
			basedOn: anHttpRequest
			within: aContext ]
		on: DataStreamIsEmpty
		do: [ :signal | signal resume: 'N/A' ]
]

{ #category : #API }
DataStreamsRESTfulController >> getStreamsBasedOn: anHttpRequest within: aContext [

	^ [ self
			get: [ 
				aContext hold: self metadataSystem under: #metadata_system.
				self dataManagementSystem streams ]
			asCollectionEncodedUsing: #data_streams
			basedOn: anHttpRequest
			within: aContext ]
		on: DataStreamIsEmpty
		do: [ :signal | signal resume: 'N/A' ]
]

{ #category : #'private - API' }
DataStreamsRESTfulController >> identifierOf: aDataStream [

	^ self identifierSystem identifierOf: aDataStream
]

{ #category : #'private - systems' }
DataStreamsRESTfulController >> identifierSystem [

	^ cosmos systemImplementing: #IdentifierSystemInterface
]

{ #category : #initialization }
DataStreamsRESTfulController >> initializeWorkingWith: aCosmosSystem [

	cosmos := aCosmosSystem
]

{ #category : #'private - accessing' }
DataStreamsRESTfulController >> lastModificationOf: aDataStream [ 

	^ self metadataSystem 
		dataDescribing: #registration_timestamp
		of: aDataStream
]

{ #category : #'private - API' }
DataStreamsRESTfulController >> locationOf: aDataStream [

	| baseUrl |

	baseUrl := baseUrlOptional
		withContentDo: [ :theBaseUrl | theBaseUrl ]
		ifUnused: [ '' asZnUrl ].

	^ '<1p>/<2p>'
		expandMacrosWith: baseUrl / 'data-streams' asZnUrl
		with: (self identifierOf: aDataStream)
]

{ #category : #'private - systems' }
DataStreamsRESTfulController >> metadataSystem [

	^ cosmos systemImplementing: #MetadataSystemInterface
]

{ #category : #'private - accessing' }
DataStreamsRESTfulController >> provideHypermediaPolicy [

	^ NonHypermediaDrivenRESTfulControllerPolicy new
]

{ #category : #'private - accessing' }
DataStreamsRESTfulController >> providePaginationPolicy [

	^ RESTFullControllerDoNotPaginateCollectionsPolicy for: self
]

{ #category : #specification }
DataStreamsRESTfulController >> specification [

	^ DataStreamsRESTfulControllerSpecification new
]

{ #category : #'private - API' }
DataStreamsRESTfulController >> streamRequestedIn: anHttpRequest [

	^ self dataManagementSystem
		streamIdentifiedBy: (anHttpRequest at: #identifier)
]

{ #category : #'private - API' }
DataStreamsRESTfulController >> withStreamRequestedIn: anHttpRequest do: aBlock [

	aBlock value: (self streamRequestedIn: anHttpRequest)
]
