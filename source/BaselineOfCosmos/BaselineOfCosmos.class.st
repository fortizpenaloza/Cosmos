Class {
	#name : #BaselineOfCosmos,
	#superclass : #BaselineOf,
	#category : #BaselineOfCosmos
}

{ #category : #baselines }
BaselineOfCosmos >> baseline: spec [

	<baseline>
	spec
		for: #pharo
		do: [ self
				setUpDependencies: spec;
				describeCosmosDependeciesOn: spec;
				describeCodeQualityDependenciesOn: spec;
				describeToolsDependeciesOn: spec.

			spec
				group: 'Deployment' with: #('Model' 'API' 'CommandLineHandler');
				group: 'Tests'
					with:
					#('Model-Tests' 'API-Tests' 'CommandLineHandler-Tests' 'Code-Quality-Tests');
				group: 'Tools' with: #('Cosmos-Tools');
				group: 'CI' with: #('Tests');
				group: 'Development' with: #('Tests' 'Tools');
				group: 'default' with: #('Development') ]
]

{ #category : #'private - baselines' }
BaselineOfCosmos >> describeAPIDependenciesOn: spec [

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
BaselineOfCosmos >> describeAPITestsDependenciesOn: spec [

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
BaselineOfCosmos >> describeCodeQualityDependenciesOn: spec [

	spec
		package: 'Cosmos-Code-Quality-Tests';
		group: 'Code-Quality-Tests' with: 'Cosmos-Code-Quality-Tests'
]

{ #category : #'private - baselines' }
BaselineOfCosmos >> describeCommandLineHandlerDependenciesOn: spec [

	spec
		package: 'Cosmos-CommandLineHandler'
			with: [ spec requires: 'ApplicationStarter' ];
		group: 'CommandLineHandler' with: 'Cosmos-CommandLineHandler'
]

{ #category : #'private - baselines' }
BaselineOfCosmos >> describeCommandLineHandlerTestsDependenciesOn: spec [

	spec
		package: 'Cosmos-CommandLineHandler-Tests'
			with: [ spec requires: 'Cosmos-CommandLineHandler' ];
		group: 'CommandLineHandler-Tests'
			with: 'Cosmos-CommandLineHandler-Tests'
]

{ #category : #'private - baselines' }
BaselineOfCosmos >> describeCosmosDependeciesOn: spec [

	self
		describeModelDependenciesOn: spec;
		describeAPIDependenciesOn: spec;
		describeCommandLineHandlerDependenciesOn: spec;
		describeModelTestsDependenciesOn: spec;
		describeAPITestsDependenciesOn: spec;
		describeCommandLineHandlerTestsDependenciesOn: spec
]

{ #category : #'private - baselines' }
BaselineOfCosmos >> describeModelDependenciesOn: spec [

	spec
		package: 'Cosmos-Metadata' with: [ spec requires: 'Kepler' ];
		group: 'Model' with: 'Cosmos-Metadata';
		package: 'Cosmos-Timestamping'
			with: [ spec requires: #('Kepler' 'Cosmos-Metadata') ];
		group: 'Model' with: 'Cosmos-Timestamping';
		package: 'Cosmos-Identifier'
			with: [ spec requires: #('Kepler' 'Cosmos-Metadata') ];
		group: 'Model' with: 'Cosmos-Identifier';
		package: 'Cosmos-Data'
			with:
				[ spec requires: #('Kepler' 'Cosmos-Identifier' 'Cosmos-Timestamping') ];
		group: 'Model' with: 'Cosmos-Data';
		package: 'Cosmos-Triggers' with: [ spec requires: 'Kepler' ];
		group: 'Model' with: 'Cosmos-Triggers';
		package: 'Cosmos-Commands' with: [ spec requires: 'Kepler' ];
		group: 'Model' with: 'Cosmos-Commands';
		package: 'Cosmos-Actions' with: [ spec requires: 'Kepler' ];
		group: 'Model' with: 'Cosmos-Actions';
		package: 'Cosmos-ActionEvaluation'
			with: [ spec requires: 'Kepler' ];
		group: 'Model' with: 'Cosmos-ActionEvaluation';
		package: 'Cosmos-PeriodicalScheduler-Core';
		group: 'Model' with: 'Cosmos-PeriodicalScheduler-Core';
		package: 'Cosmos-ActionEvaluator';
		group: 'Model' with: 'Cosmos-ActionEvaluator'
]

{ #category : #'private - baselines' }
BaselineOfCosmos >> describeModelTestsDependenciesOn: spec [

	spec
		package: 'Cosmos-Tests';
		group: 'Model-Tests' with: 'Cosmos-Tests';
		package: 'Cosmos-UserStoryTests'
			with: [ spec requires: #('Cosmos-Model' 'Kepler-SUnit') ];
		group: 'Model-Tests' with: 'Cosmos-UserStoryTests';
		package: 'Cosmos-Identifier-Tests'
			with: [ spec requires: 'Cosmos-Identifier' ];
		group: 'Model-Tests' with: 'Cosmos-Identifier-Tests';
		package: 'Cosmos-Metadata-Tests'
			with: [ spec requires: 'Cosmos-Metadata' ];
		group: 'Model-Tests' with: 'Cosmos-Metadata-Tests';
		package: 'Cosmos-Timestamping-Tests'
			with: [ spec requires: #('Cosmos-Tests' 'Cosmos-Timestamping') ];
		group: 'Model-Tests' with: 'Cosmos-Timestamping-Tests';
		package: 'Cosmos-Data-Tests'
			with: [ spec
				requires: #('Cosmos-Tests' 'Cosmos-Data' 'Cosmos-UserStoryTests') ];
		group: 'Model-Tests' with: 'Cosmos-Data-Tests';
		package: 'Cosmos-Triggers-Tests'
			with: [ spec
				requires: #('Cosmos-Tests' 'Cosmos-Triggers' 'Cosmos-UserStoryTests') ];
		group: 'Model-Tests' with: 'Cosmos-Triggers-Tests';
		package: 'Cosmos-Commands-Tests'
			with: [ spec
				requires: #('Cosmos-Tests' 'Cosmos-Commands' 'Cosmos-UserStoryTests') ];
		group: 'Model-Tests' with: 'Cosmos-Commands-Tests';
		package: 'Cosmos-Actions-Tests'
			with: [ spec
				requires: #('Cosmos-Tests' 'Cosmos-Actions' 'Cosmos-UserStoryTests') ];
		group: 'Model-Tests' with: 'Cosmos-Actions-Tests';
		package: 'Cosmos-ActionEvaluation-Tests'
			with: [ spec
				requires: #('Cosmos-Tests' 'Cosmos-ActionEvaluation' 'Cosmos-UserStoryTests') ];
		group: 'Model-Tests' with: 'Cosmos-ActionEvaluation-Tests';
		package: 'Cosmos-PeriodicalScheduler-Tests'
			with: [ spec requires: #('Cosmos-PeriodicalScheduler-Core') ];
		group: 'Model-Tests' with: 'Cosmos-PeriodicalScheduler-Tests';
		package: 'Cosmos-ActionEvaluator-Tests'
			with: [ spec requires: #('Cosmos-ActionEvaluator') ];
		group: 'Model-Tests' with: 'Cosmos-ActionEvaluator-Tests'
]

{ #category : #'private - baselines' }
BaselineOfCosmos >> describeToolsDependeciesOn: spec [

	spec
		package: 'Cosmos-Tools'
		with: [ spec requires: #('Roassal2' 'Kepler-Tools' 'Stargate-Tools') ]
]

{ #category : #accessing }
BaselineOfCosmos >> projectClass [

	^ MetacelloCypressBaselineProject
]

{ #category : #dependencies }
BaselineOfCosmos >> setUpDependencies: spec [

	spec
		baseline: 'Kepler'
			with: [ spec
				repository: 'github://ba-st/Kepler:v4/source';
				loads: #('Deployment') ];
		project: 'Kepler-SUnit' copyFrom: 'Kepler' with: [ spec loads: 'Dependent-SUnit-Extensions' ];
		project: 'Kepler-Tools' copyFrom: 'Kepler' with: [ spec loads: 'Tools' ].
		
	spec
		baseline: 'Stargate'
		with: [ spec
				repository: 'github://ba-st/Stargate:v1/source';
				loads: 'Deployment' ];
		project: 'Stargate-Tools' copyFrom: 'Stargate' with: [ spec loads: 'Tools' ].
			
		
	spec
		baseline: 'ApplicationStarter'
			with: [ spec
				repository: 'github://ba-st/ApplicationStarter:v1/source';
				loads: 'Deployment' ];
		import: 'ApplicationStarter'.

	spec
		baseline: 'Roassal2'
			with: [ spec
				repository: 'github://ObjectProfile/Roassal2/src';
				loads: #('Minimal') ];
		import: 'Roassal2'
]
