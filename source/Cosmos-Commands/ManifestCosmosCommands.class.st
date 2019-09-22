Class {
	#name : #ManifestCosmosCommands,
	#superclass : #PackageManifest,
	#category : #'Cosmos-Commands-Manifest'
}

{ #category : #'class initialization' }
ManifestCosmosCommands class >> initialize [

	<ignoreForCoverage>
	Kepler
		registerInterfaceAt: #CommandManagementSystemInterface
		named: 'Command Management System Interface'
		declaring: #(#register: #deregister: #nextCommand #commands)
]
