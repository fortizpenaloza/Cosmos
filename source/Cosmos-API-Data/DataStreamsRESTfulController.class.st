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
		decodedUsing: self specification dataStreamsMappingKey
		basedOn: anHttpRequest
		within: aContext ]
		on: InstanceCreationFailed
		do: [ :signal | HTTPClientError signalBadRequest: signal messageText ]
]

{ #category : #'private - systems' }
DataStreamsRESTfulController >> dataManagementSystem [

	^ cosmos systemImplementing: #DataManagementSystemInterface
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

{ #category : #'private - accessing' }
DataStreamsRESTfulController >> entityTagOf: aDataStream encodedAs: aMediaType [

	^ ZnETag
		with:
			(SHA1 new
				hashMessage:
					('<1s>-<2s>-<3s>'
						expandMacrosWith: (self identifierOf: aDataStream) asString
						with: (self lastModificationOf: aDataStream) asString
						with: aMediaType asString)) hex
]

{ #category : #API }
DataStreamsRESTfulController >> getPointsBasedOn: anHttpRequest within: aContext [

	| mediaType resourceCollection encodedResourceCollection |

	mediaType := self targetMediaTypeFrom: anHttpRequest.
		resourceCollection := self
		evaluateQuery: [ (self streamRequestedIn: anHttpRequest) dataPoints ].

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

{ #category : #'private - accessing' }
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

{ #category : #'private - accessing' }
DataStreamsRESTfulController >> locationOf: aDataStream [

	| baseUrl |

	baseUrl := baseUrlOptional
		withContentDo: [ :theBaseUrl | theBaseUrl ]
		ifUnused: [ '' asZnUrl ].

	^ baseUrl / self specification endpoint / (self identifierOf: aDataStream) asString 
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

	^ RESTfulControllerDoNotPaginateCollectionsPolicy for: self
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
