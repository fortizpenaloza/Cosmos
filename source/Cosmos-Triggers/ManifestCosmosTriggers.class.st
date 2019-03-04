Class {
	#name : #ManifestCosmosTriggers,
	#superclass : #PackageManifest,
	#category : #'Cosmos-Triggers-Manifest'
}

{ #category : #'class initialization' }
ManifestCosmosTriggers class >> initialize [

	<ignoreForCoverage>
	Kepler
		registerInterfaceAt: #TriggerManagementSystemInterface
		named: 'Trigger Management System Interface'
		declaring:
			#(#register: #deregister: #handleTickOn: #handleDataPointRegistrationOn: #triggers #triggerIdentifiedBy:)
]
