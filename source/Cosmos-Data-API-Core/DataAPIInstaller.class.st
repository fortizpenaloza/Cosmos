Class {
	#name : #DataAPIInstaller,
	#superclass : #Object,
	#instVars : [
		'server',
		'interface'
	],
	#category : #'Cosmos-Data-API-Core'
}

{ #category : #'instance creation' }
DataAPIInstaller class >> toWorkWith: aCompositeSystem on: aServer [
	
	^ self new initializeToWorkWith: aCompositeSystem on: aServer
]

{ #category : #'private-installing' }
DataAPIInstaller >> addBulkDataPointRegistrationRoute [

	server
		POST:
			'/data-points'
				-> [ :request | interface registerBulkPointsFrom: request contents ];
		output: #text
]

{ #category : #'private-installing' }
DataAPIInstaller >> addGetDataStreamRoute [

	server
		GET:
			'/data-streams/<name>'
				-> [ :request | interface streamNamed: (request at: #name) ]
]

{ #category : #'private-installing' }
DataAPIInstaller >> addGetDataStreamSnapshotsRoute [

	server GET: '/data-streams' -> [ :request | interface streams ]
]

{ #category : #'private-installing' }
DataAPIInstaller >> addRegisterDataStreamRoute [

	server
		POST:
			'/data-streams'
				-> [ :request | interface registerStreamFrom: request contents ];
		output: #text
]

{ #category : #initialization }
DataAPIInstaller >> initializeToWorkWith: aCompositeSystem on: aServer [

	interface := DataAPI workingWithin: (DataAPIContext workingWith: aCompositeSystem).
	server := aServer
]

{ #category : #installing }
DataAPIInstaller >> install [

	self
		addGetDataStreamSnapshotsRoute;
		addGetDataStreamRoute;
		addRegisterDataStreamRoute;
		addBulkDataPointRegistrationRoute
]
