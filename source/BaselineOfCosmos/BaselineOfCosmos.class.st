Class {
	#name : #BaselineOfCosmos,
	#superclass : #BaselineOf,
	#category : #BaselineOfCosmos
}

{ #category : #'private - baselines building' }
BaselineOfCosmos >> add: aPackage to: aGroup requiring: aPackageSet on: aSpec [

	aSpec
		package: aPackage with: [ aSpec requires: aPackageSet ];
		group: aGroup with: aPackage
]

{ #category : #'private - baselines building' }
BaselineOfCosmos >> add: aPackage toAPIRequiring: aRequiredPakageSet on: aSpec [

	self
		add: aPackage
		to: 'API'
		requiring: aRequiredPakageSet
		on: aSpec
]

{ #category : #'private - baselines building' }
BaselineOfCosmos >> add: aPackage toAPITestsRequiring: aRequiredPakageSet on: aSpec [

	self
		add: aPackage
		to: 'API-Tests'
		requiring: aRequiredPakageSet
		on: aSpec
]

{ #category : #'private - baselines building' }
BaselineOfCosmos >> add: aPackage toModelRequiring: aRequiredPakageSet on: aSpec [

	self
		add: aPackage
		to: 'Model'
		requiring: aRequiredPakageSet
		on: aSpec
]

{ #category : #'private - baselines building' }
BaselineOfCosmos >> add: aPackage toModelTestsRequiring: aRequiredPakageSet on: aSpec [

	self
		add: aPackage
		to: 'Model-Tests'
		requiring: aRequiredPakageSet
		on: aSpec
]

{ #category : #baselines }
BaselineOfCosmos >> baseline: spec [

	<baseline>
	spec
		for: #pharo
		do: [ self
				setUpDependeciesOn: spec;
				setUpPackageDependeciesOn: spec;
				setUpCompatibilityPackagesOn: spec;
				setUpGroupsOn: spec ].

	
]

{ #category : #accessing }
BaselineOfCosmos >> projectClass [

	^ MetacelloCypressBaselineProject
]

{ #category : #'private - baselines' }
BaselineOfCosmos >> setUpAPIDependenciesOn: spec [

	self
		add: 'Cosmos-API-Common' toAPIRequiring: 'Stargate' on: spec;
		add: 'Cosmos-API-Data'
			toAPIRequiring: #('Cosmos-API-Common' 'Cosmos-Data')
			on: spec;
		add: 'Cosmos-API-Commands'
			toAPIRequiring: #('Cosmos-API-Common' 'Cosmos-Commands')
			on: spec;
		add: 'Cosmos-API-Actions'
			toAPIRequiring: #('Cosmos-API-Common' 'Cosmos-Actions' 'Cosmos-ActionEvaluation')
			on: spec;
		add: 'Cosmos-API-Triggers'
			toAPIRequiring: #('Cosmos-API-Common' 'Cosmos-Triggers')
			on: spec
]

{ #category : #'private - baselines' }
BaselineOfCosmos >> setUpAPITestsDependenciesOn: spec [

	self
		add: 'Cosmos-API-Common-Tests'
			toAPITestsRequiring: #('Cosmos-API-Common' 'Cosmos-UserStoryTests')
			on: spec;
		add: 'Cosmos-API-Data-Tests'
			toAPITestsRequiring: #('Cosmos-API-Data' 'Cosmos-UserStoryTests')
			on: spec;
		add: 'Cosmos-API-Commands-Tests'
			toAPITestsRequiring: #('Cosmos-API-Commands' 'Cosmos-UserStoryTests')
			on: spec;
		add: 'Cosmos-API-Actions-Tests'
			toAPITestsRequiring: #('Cosmos-API-Actions' 'Cosmos-UserStoryTests')
			on: spec;
		add: 'Cosmos-API-Triggers-Tests'
			toAPITestsRequiring: #('Cosmos-API-Triggers' 'Cosmos-UserStoryTests')
			on: spec
]

{ #category : #'private - baselines' }
BaselineOfCosmos >> setUpCodeQualityDependenciesOn: spec [

	spec
		package: 'Cosmos-Code-Quality-Tests';
		group: 'Code-Quality-Tests' with: 'Cosmos-Code-Quality-Tests'
]

{ #category : #'private - baselines' }
BaselineOfCosmos >> setUpCommandLineHandlerDependenciesOn: spec [

	spec
		package: 'Cosmos-CommandLineHandler'
			with: [ spec requires: 'ApplicationStarter' ];
		group: 'CommandLineHandler' with: 'Cosmos-CommandLineHandler'
]

{ #category : #'private - baselines' }
BaselineOfCosmos >> setUpCommandLineHandlerTestsDependenciesOn: spec [

	spec
		package: 'Cosmos-CommandLineHandler-Tests'
			with: [ spec requires: 'Cosmos-CommandLineHandler' ];
		group: 'CommandLineHandler-Tests'
			with: 'Cosmos-CommandLineHandler-Tests'
]

{ #category : #'private - baselines' }
BaselineOfCosmos >> setUpCompatibilityPackagesOn: spec [

	spec
		for: #'pharo6.x'
		do: [ spec
				package: 'Cosmos-CommandLineHandler-Pharo6';
				group: 'CommandLineHandler'
					with: 'Cosmos-CommandLineHandler-Pharo6' ].
	spec
		for: #'pharo7.x'
		do: [ spec
				package: 'Cosmos-CommandLineHandler-Pharo7';
				group: 'CommandLineHandler'
					with: 'Cosmos-CommandLineHandler-Pharo7' ]
]

{ #category : #'private - baselines' }
BaselineOfCosmos >> setUpCosmosDependeciesOn: spec [

	self
		setUpModelDependenciesOn: spec;
		setUpAPIDependenciesOn: spec;
		setUpCommandLineHandlerDependenciesOn: spec;
		setUpModelTestsDependenciesOn: spec;
		setUpAPITestsDependenciesOn: spec;
		setUpCommandLineHandlerTestsDependenciesOn: spec
]

{ #category : #dependencies }
BaselineOfCosmos >> setUpDependeciesOn: aSpec [

	aSpec
		baseline: 'Kepler'
			with: [ aSpec
				repository: 'github://ba-st/Kepler:v4/source';
				loads: #('Deployment') ];
		project: 'Kepler-SUnit' copyFrom: 'Kepler' with: [ aSpec loads: 'Dependent-SUnit-Extensions' ];
		project: 'Kepler-Tools' copyFrom: 'Kepler' with: [ aSpec loads: 'Tools' ].
		
	aSpec
		baseline: 'Stargate'
		with: [ aSpec
				repository: 'github://ba-st/Stargate:v1/source';
				loads: 'Deployment' ];
		project: 'Stargate-Tools' copyFrom: 'Stargate' with: [ aSpec loads: 'Tools' ].
			
		
	aSpec
		baseline: 'ApplicationStarter'
			with: [ aSpec
				repository: 'github://ba-st/ApplicationStarter:v1/source';
				loads: 'Deployment' ];
		import: 'ApplicationStarter'.

	aSpec
		baseline: 'Roassal2'
			with: [ aSpec
				repository: 'github://ObjectProfile/Roassal2/src';
				loads: #('Minimal') ];
		import: 'Roassal2'
]

{ #category : #groups }
BaselineOfCosmos >> setUpGroupsOn: spec [

	^ spec
		group: 'Deployment' with: #('Model' 'API' 'CommandLineHandler');
		group: 'Tests'
			with:
			#('Model-Tests' 'API-Tests' 'CommandLineHandler-Tests' 'Code-Quality-Tests');
		group: 'Tools' with: #('Cosmos-Tools');
		group: 'CI' with: #('Tests');
		group: 'Development' with: #('Tests' 'Tools');
		group: 'default' with: #('Development')
]

{ #category : #'private - baselines' }
BaselineOfCosmos >> setUpModelDependenciesOn: spec [

	self
		add: 'Cosmos-Metadata' toModelRequiring: 'Kepler' on: spec;
		add: 'Cosmos-Timestamping'
			toModelRequiring: #('Kepler' 'Cosmos-Metadata')
			on: spec;
		add: 'Cosmos-Identifier'
			toModelRequiring: #('Kepler' 'Cosmos-Metadata')
			on: spec;
		add: 'Cosmos-Data'
			toModelRequiring: #('Kepler' 'Cosmos-Identifier' 'Cosmos-Timestamping')
			on: spec;
		add: 'Cosmos-Triggers'
			toModelRequiring: #('Kepler' 'Cosmos-Data' 'Cosmos-Identifier' 'Cosmos-Timestamping')
			on: spec;
		add: 'Cosmos-Commands' toModelRequiring: 'Kepler' on: spec;
		add: 'Cosmos-Actions' toModelRequiring: 'Kepler' on: spec;
		add: 'Cosmos-ActionEvaluation'
			toModelRequiring: #('Kepler' 'Cosmos-Identifier' 'Cosmos-Timestamping')
			on: spec;
		add: 'Cosmos-PeriodicalScheduler-Core'
			toModelRequiring: #()
			on: spec;
		add: 'Cosmos-ActionEvaluator' toModelRequiring: #() on: spec
]

{ #category : #'private - baselines' }
BaselineOfCosmos >> setUpModelTestsDependenciesOn: spec [

	self
		add: 'Cosmos-SUnit-Model' toModelTestsRequiring: #() on: spec;
		add: 'Cosmos-Metadata-Tests'
			toModelTestsRequiring: #('Kepler-SUnit' 'Cosmos-Metadata')
			on: spec;
		add: 'Cosmos-Identifier-Tests'
			toModelTestsRequiring: #('Kepler-SUnit' 'Cosmos-Identifier')
			on: spec;
		add: 'Cosmos-Timestamping-Tests'
			toModelTestsRequiring: #('Kepler-SUnit' 'Cosmos-Timestamping')
			on: spec;
		add: 'Cosmos-Data-Tests'
			toModelTestsRequiring: #('Kepler-SUnit' 'Cosmos-Data')
			on: spec;
		add: 'Cosmos-Triggers-Tests'
			toModelTestsRequiring: #('Kepler-SUnit' 'Cosmos-Triggers')
			on: spec;
		add: 'Cosmos-Commands-Tests'
			toModelTestsRequiring:
			#('Cosmos-SUnit-Model' 'Kepler-SUnit' 'Cosmos-Commands' 'Cosmos-UserStoryTests')
			on: spec;
		add: 'Cosmos-Actions-Tests'
			toModelTestsRequiring: #('Cosmos-SUnit-Model' 'Kepler-SUnit' 'Cosmos-Actions')
			on: spec;
		add: 'Cosmos-ActionEvaluation-Tests'
			toModelTestsRequiring: #('Kepler-SUnit' 'Cosmos-ActionEvaluation')
			on: spec;
		add: 'Cosmos-PeriodicalScheduler-Tests'
			toModelTestsRequiring: #('Cosmos-PeriodicalScheduler-Core')
			on: spec;
		add: 'Cosmos-ActionEvaluator-Tests'
			toModelTestsRequiring: #('Cosmos-ActionEvaluator')
			on: spec;
		add: 'Cosmos-UserStoryTests'
			toModelTestsRequiring: #('Model' 'Kepler-SUnit')
			on: spec
]

{ #category : #'private - baselines' }
BaselineOfCosmos >> setUpPackageDependeciesOn: aSpec [

	self
		setUpCosmosDependeciesOn: aSpec;
		setUpCodeQualityDependenciesOn: aSpec;
		setUpToolsDependeciesOn: aSpec
]

{ #category : #'private - baselines' }
BaselineOfCosmos >> setUpToolsDependeciesOn: spec [

	spec
		package: 'Cosmos-Tools'
		with: [ spec requires: #('Roassal2' 'Kepler-Tools' 'Stargate-Tools') ]
]
