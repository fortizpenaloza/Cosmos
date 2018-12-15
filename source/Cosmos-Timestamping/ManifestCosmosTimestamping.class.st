Class {
	#name : #ManifestCosmosTimestamping,
	#superclass : #PackageManifest,
	#category : #'Cosmos-Timestamping-Manifest'
}

{ #category : #'class initialization' }
ManifestCosmosTimestamping class >> initialize [

	<ignoreForCoverage>
	Kepler
		registerInterfaceAt: #TimestampingSystemInterface
		named: 'Timestamping System Interface'
		declaring: #(#name #registerModificationFor: #lastModificationOf:)
]
