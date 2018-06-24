Class {
	#name : #DataAPIInstaller,
	#superclass : #Object,
	#instVars : [
		'server',
		'interface'
	],
	#category : #'Cosmos-API-Data'
}

{ #category : #'instance creation' }
DataAPIInstaller class >> toInstallOn: aServer workingWith: aCosmosSystem [

	^ self new initializeToInstallOn: aServer workingWith: aCosmosSystem
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
DataAPIInstaller >> initializeToInstallOn: aServer workingWith: aCosmosSystem [

	interface := DataAPI workingWithin: aCosmosSystem.
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
