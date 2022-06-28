"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestCosmosAPITriggersTests,
	#superclass : #PackageManifest,
	#category : #'Cosmos-API-Triggers-Tests-Manifest'
}

{ #category : #'code-critics' }
ManifestCosmosAPITriggersTests class >> ruleSentNotImplementedRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#TriggersRESTfulControllerTest #testGetTrigger #false)) #'2022-06-28T00:32:53.469763-03:00') #(#(#RGMethodDefinition #(#TriggersRESTfulControllerTest #testGetTriggerIncludesSetTriggeredToTrueAfterDataPointWasRegisteredOnTemperatureJustCreated #false)) #'2022-06-28T00:33:33.202924-03:00') )
]
