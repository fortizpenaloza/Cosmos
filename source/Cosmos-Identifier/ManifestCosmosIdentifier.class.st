"
I store metadata for this package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
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
		declaring: #(#identifierOf: #objectIdentifiedBy:ifNone: #registerIdentifierFor:)
]
