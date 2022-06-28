"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestCosmosCommandLineHandlerTests,
	#superclass : #PackageManifest,
	#category : #'Cosmos-CommandLineHandler-Tests-Manifest'
}

{ #category : #'code-critics' }
ManifestCosmosCommandLineHandlerTests class >> ruleSentNotImplementedRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#CosmosApplicationTest #testActivationWithAllArguments #false)) #'2022-06-27T23:31:23.197759-03:00') )
]
