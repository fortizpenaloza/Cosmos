Class {
	#name : #ManifestCosmosMetadata,
	#superclass : #PackageManifest,
	#category : #'Cosmos-Metadata-Manifest'
}

{ #category : #'class initialization' }
ManifestCosmosMetadata class >> initialize [

	<ignoreForCoverage>
	Kepler
		registerInterfaceAt: #MetadataSystemInterface
		named: 'Metadata System Interface'
		declaring: #(#metadataFor: #register: #describedObjectBy:as:ifNone:)
]
