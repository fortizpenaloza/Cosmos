Class {
	#name : #ManifestCosmosActions,
	#superclass : #PackageManifest,
	#category : #'Cosmos-Actions-Manifest'
}

{ #category : #'class initialization' }
ManifestCosmosActions class >> initialize [

	<ignoreForCoverage>
	Kepler
		registerInterfaceAt: #ActionManagementSystemInterface
		named: 'Action Management System Interface'
		declaring: #(#register: #deregister: actions)
]
