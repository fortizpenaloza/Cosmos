Class {
	#name : #ManifestCosmosActionEvaluation,
	#superclass : #PackageManifest,
	#category : #'Cosmos-ActionEvaluation-Manifest'
}

{ #category : #'class initialization' }
ManifestCosmosActionEvaluation class >> initialize [

	<ignoreForCoverage>
	Kepler
		registerInterfaceAt: #ActionEvaluationSystemInterface
		named: 'Action Evaluation System Interface'
		declaring: #(#register: #deregister: actions)
]
