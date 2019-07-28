Class {
	#name : #BaselineOfCosmos,
	#superclass : #BaselineOf,
	#category : #BaselineOfCosmos
}

{ #category : #'private - baselines building' }
BaselineOfCosmos >> add: aPackage to: aGroup on: aSpec [

	aSpec
		package: aPackage;
		group: aGroup with: aPackage
]

{ #category : #'private - baselines building' }
BaselineOfCosmos >> add: aPackage to: aGroup requiring: aPackageSet on: aSpec [

	aSpec
		package: aPackage with: [ aSpec requires: aPackageSet ];
		group: aGroup with: aPackage
]

{ #category : #'private - baselines building' }
BaselineOfCosmos >> add: aPackage toModelOn: aSpec [

	self add: aPackage to: 'Model' on: aSpec
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
BaselineOfCosmos >> add: aPackage toModelTestsOn: aSpec [

	self add: aPackage to: 'Model-Tests' on: aSpec
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
				setUpGroupsOn: spec ]
]

{ #category : #accessing }
BaselineOfCosmos >> projectClass [

	^ MetacelloCypressBaselineProject
]

{ #category : #'private - baselines' }
BaselineOfCosmos >> setUpAPIDependenciesOn: spec [

	spec
		package: 'Cosmos-API-Common' with: [ spec requires: 'Stargate' ];
		group: 'API' with: 'Cosmos-API-Common';
		package: 'Cosmos-API-Data'
			with: [ spec requires: #('Cosmos-API-Common' 'Cosmos-Data') ];
		group: 'API' with: 'Cosmos-API-Data';
		package: 'Cosmos-API-Commands'
			with: [ spec requires: #('Cosmos-API-Common' 'Cosmos-Commands') ];
		group: 'API' with: 'Cosmos-API-Commands';
		package: 'Cosmos-API-Actions'
			with: [ spec requires: #('Cosmos-API-Common' 'Cosmos-Actions' 'Cosmos-ActionEvaluation') ];
		group: 'API' with: 'Cosmos-API-Actions';
		package: 'Cosmos-API-Triggers'
			with: [ spec requires: #('Cosmos-API-Common' 'Cosmos-Triggers') ];
		group: 'API' with: 'Cosmos-API-Triggers'
]

{ #category : #'private - baselines' }
BaselineOfCosmos >> setUpAPITestsDependenciesOn: spec [

	spec
		package: 'Cosmos-API-Common-Tests'
			with: [ spec requires: #('Cosmos-API-Common' 'Cosmos-UserStoryTests') ];
		group: 'API-Tests' with: 'Cosmos-API-Common-Tests';
		package: 'Cosmos-API-Data-Tests'
			with: [ spec requires: #('Cosmos-API-Data' 'Cosmos-UserStoryTests') ];
		group: 'API-Tests' with: 'Cosmos-API-Data-Tests';
		package: 'Cosmos-API-Commands-Tests'
			with: [ spec requires: #('Cosmos-API-Commands' 'Cosmos-UserStoryTests') ];
		group: 'API-Tests' with: 'Cosmos-API-Commands-Tests';
		package: 'Cosmos-API-Actions-Tests'
			with: [ spec requires: #('Cosmos-API-Actions' 'Cosmos-UserStoryTests') ];
		group: 'API-Tests' with: 'Cosmos-API-Actions-Tests';
		package: 'Cosmos-API-Triggers-Tests'
			with: [ spec requires: #('Cosmos-API-Triggers' 'Cosmos-UserStoryTests') ];
		group: 'API-Tests' with: 'Cosmos-API-Triggers-Tests'
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
		add: 'Cosmos-PeriodicalScheduler-Core' toModelOn: spec;
		add: 'Cosmos-ActionEvaluator' toModelOn: spec
]

{ #category : #'private - baselines' }
BaselineOfCosmos >> setUpModelTestsDependenciesOn: spec [

	self
		add: 'Cosmos-SUnit-Model' toModelTestsOn: spec;
		add: 'Cosmos-Metadata-Tests'
			toModelTestsRequiring: #('Kepler-SUnit' 'Cosmos-Metadata')
			on: spec.

	spec
		package: 'Cosmos-Identifier-Tests'
			with: [ spec requires: #('Kepler-SUnit' 'Cosmos-Identifier') ];
		group: 'Model-Tests' with: 'Cosmos-Identifier-Tests';
		package: 'Cosmos-Timestamping-Tests'
			with: [ spec requires: #('Kepler-SUnit' 'Cosmos-Timestamping') ];
		group: 'Model-Tests' with: 'Cosmos-Timestamping-Tests';
		package: 'Cosmos-Data-Tests'
			with: [ spec requires: #('Kepler-SUnit' 'Cosmos-Data') ];
		group: 'Model-Tests' with: 'Cosmos-Data-Tests';
		package: 'Cosmos-Triggers-Tests'
			with: [ spec requires: #('Kepler-SUnit' 'Cosmos-Triggers') ];
		group: 'Model-Tests' with: 'Cosmos-Triggers-Tests';
		package: 'Cosmos-Commands-Tests'
			with: [ spec
				requires:
					#('Cosmos-SUnit-Model' 'Kepler-SUnit' 'Cosmos-Commands' 'Cosmos-UserStoryTests') ];
		group: 'Model-Tests' with: 'Cosmos-Commands-Tests';
		package: 'Cosmos-Actions-Tests'
			with: [ spec
				requires: #('Cosmos-SUnit-Model' 'Kepler-SUnit' 'Cosmos-Actions') ];
		group: 'Model-Tests' with: 'Cosmos-Actions-Tests';
		package: 'Cosmos-ActionEvaluation-Tests'
			with: [ spec requires: #('Kepler-SUnit' 'Cosmos-ActionEvaluation') ];
		group: 'Model-Tests' with: 'Cosmos-ActionEvaluation-Tests';
		package: 'Cosmos-PeriodicalScheduler-Tests'
			with: [ spec requires: #('Cosmos-PeriodicalScheduler-Core') ];
		group: 'Model-Tests' with: 'Cosmos-PeriodicalScheduler-Tests';
		package: 'Cosmos-ActionEvaluator-Tests'
			with: [ spec requires: #('Cosmos-ActionEvaluator') ];
		group: 'Model-Tests' with: 'Cosmos-ActionEvaluator-Tests';
		package: 'Cosmos-UserStoryTests'
			with: [ spec requires: #('Model' 'Kepler-SUnit') ];
		group: 'Model-Tests' with: 'Cosmos-UserStoryTests'
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
