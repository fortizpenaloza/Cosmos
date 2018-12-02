"
I store metadata for this package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
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
