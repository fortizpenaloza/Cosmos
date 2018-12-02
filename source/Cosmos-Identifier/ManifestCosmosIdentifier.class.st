Class {
	#name : #ManifestCosmosIdentifier,
	#superclass : #PackageManifest,
	#category : #'Cosmos-Identifier-Manifest'
}

{ #category : #'class initialization' }
ManifestCosmosIdentifier class >> initialize [

	<ignoreForCoverage>
	Kepler
		registerInterfaceAt:  #IdentifierSystemInterface
		named: 'Identifier System Interface'
		declaring: #(#next)
]
