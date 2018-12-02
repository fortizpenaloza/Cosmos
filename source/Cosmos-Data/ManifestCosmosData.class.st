"
I store metadata for this package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestCosmosData,
	#superclass : #PackageManifest,
	#category : #'Cosmos-Data-Manifest'
}

{ #category : #'class initialization' }
ManifestCosmosData class >> initialize [

	<ignoreForCoverage>
	Kepler
		registerInterfaceAt: #DataStreamManagementSystemInterface
		named: 'Data Stream Management System Interface'
		declaring: #(#register: #deregister: #register:toStreamNamed: #streamIdentifiedBy: #streams)
]
