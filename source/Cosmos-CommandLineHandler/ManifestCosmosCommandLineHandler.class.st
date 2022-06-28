"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestCosmosCommandLineHandler,
	#superclass : #PackageManifest,
	#category : #'Cosmos-CommandLineHandler-Manifest'
}

{ #category : #'code-critics' }
ManifestCosmosCommandLineHandler class >> ruleSentNotImplementedRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#CosmosApplication #apiConfiguration #false)) #'2022-06-27T23:05:16.261624-03:00') )
]
