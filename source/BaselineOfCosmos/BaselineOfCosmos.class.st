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
				describeCosmosDependeciesOn: spec.

			spec package: 'Cosmos-Code-Quality-Tests'.

			spec package: 'Cosmos-Tools' with: [ spec requires: #('Roassal2' 'Kepler-Tools' 'Stargate-Tools') ].

			spec
				group: 'Deployment'
					with: #('Cosmos-Model' 'Cosmos-API-Model' 'Cosmos-CommandLineHandler');
				group: 'Tests'
					with:
					#('Cosmos-Model-Tests' 'Cosmos-API-Model-Tests' 'Cosmos-CommandLineHandler-Tests' 'Cosmos-Code-Quality-Tests');
				group: 'Tools' with: #('Cosmos-Tools');
				group: 'CI' with: #('Deployment' 'Tests');
				group: 'Development' with: #('CI' 'Tools');
				group: 'default' with: #('Development') ]
]

{ #category : #'private - baselines' }
BaselineOfCosmos >> describeAPIDependenciesOn: spec [

	spec
		package: 'Cosmos-API-Common' with: [ spec requires: #('Stargate') ];
		group: 'Deployment' with: 'Cosmos-API-Common';
		package: 'Cosmos-API-Data'
			with: [ spec requires: #('Cosmos-API-Common' 'Cosmos-Data') ];
		group: 'Deployment' with: 'Cosmos-API-Data';
		package: 'Cosmos-API-Commands'
			with: [ spec requires: #('Cosmos-API-Common' 'Cosmos-Commands') ];
		group: 'Deployment' with: 'Cosmos-API-Commands';
		package: 'Cosmos-API-Actions'
			with: [ spec requires: #('Cosmos-API-Common' 'Cosmos-Actions') ];
		group: 'Deployment' with: 'Cosmos-API-Actions';
		package: 'Cosmos-API-Triggers'
			with: [ spec requires: #('Cosmos-API-Common' 'Cosmos-Triggers') ];
		group: 'Deployment' with: 'Cosmos-API-Triggers'
]

{ #category : #'private - baselines' }
BaselineOfCosmos >> describeAPITestsDependenciesOn: spec [

	spec
		package: 'Cosmos-API-Common-Tests' with: [ spec requires: #('Cosmos-API-Common' 'Cosmos-UserStoryTests') ];
		package: 'Cosmos-API-Data-Tests' with: [ spec requires: #('Cosmos-API-Data' 'Cosmos-UserStoryTests') ];
		package: 'Cosmos-API-Commands-Tests' with: [ spec requires: #('Cosmos-API-Commands' 'Cosmos-UserStoryTests') ];
		package: 'Cosmos-API-Actions-Tests' with: [ spec requires: #('Cosmos-API-Actions' 'Cosmos-UserStoryTests') ];
		package: 'Cosmos-API-Triggers-Tests' with: [ spec requires: #('Cosmos-API-Triggers' 'Cosmos-UserStoryTests') ].

	spec
		group: 'Cosmos-API-Model-Tests'
		with: #('Cosmos-API-Common-Tests' 'Cosmos-API-Data-Tests' 'Cosmos-API-Commands-Tests' 'Cosmos-API-Actions-Tests' 'Cosmos-API-Triggers-Tests')
]

{ #category : #'private - baselines' }
BaselineOfCosmos >> describeCommandLineHandlerDependenciesOn: spec [

	spec
		package: 'Cosmos-CommandLineHandler'
			with: [ spec requires: #('ApplicationStarter') ];
		group: 'Deployment' with: 'Cosmos-CommandLineHandler'
]

{ #category : #'private - baselines' }
BaselineOfCosmos >> describeCommandLineHandlerTestsDependenciesOn: spec [

	spec
		package: 'Cosmos-CommandLineHandler-Tests'
		with: [ spec requires: #('Cosmos-CommandLineHandler') ]
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
		package: 'Cosmos-Identifier' with: [ spec requires: #('Kepler') ];
		group: 'Deployment' with: 'Cosmos-Identifier';
		package: 'Cosmos-Metadata' with: [ spec requires: #('Kepler') ];
		group: 'Deployment' with: 'Cosmos-Metadata';
		package: 'Cosmos-Timestamping' with: [ spec requires: #('Kepler') ];
		group: 'Deployment' with: 'Cosmos-Timestamping';
		package: 'Cosmos-Data' with: [ spec requires: #('Kepler') ];
		group: 'Deployment' with: 'Cosmos-Data';
		package: 'Cosmos-Triggers' with: [ spec requires: #('Kepler') ];
		group: 'Deployment' with: 'Cosmos-Triggers';
		package: 'Cosmos-Commands' with: [ spec requires: #('Kepler') ];
		group: 'Deployment' with: 'Cosmos-Commands';
		package: 'Cosmos-Actions' with: [ spec requires: #('Kepler') ];
		group: 'Deployment' with: 'Cosmos-Actions';
		package: 'Cosmos-PeriodicalScheduler-Core';
		group: 'Deployment' with: 'Cosmos-PeriodicalScheduler-Core';
		package: 'Cosmos-ActionEvaluator-Core';
		group: 'Deployment' with: 'Cosmos-ActionEvaluator-Core'
]

{ #category : #'private - baselines' }
BaselineOfCosmos >> describeModelTestsDependenciesOn: spec [

	spec
		package: 'Cosmos-Tests';
		package: 'Cosmos-UserStoryTests'
			with: [ spec requires: #('Cosmos-Data' 'Cosmos-Commands' 'Cosmos-Triggers' 'Kepler-SUnit') ];
		package: 'Cosmos-Identifier-Tests'
			with: [ spec requires: #('Cosmos-Tests' 'Cosmos-Identifier') ];
		package: 'Cosmos-Metadata-Tests'
			with: [ spec requires: #('Cosmos-Tests' 'Cosmos-Metadata') ];
		package: 'Cosmos-Timestamping-Tests'
			with: [ spec requires: #('Cosmos-Tests' 'Cosmos-Timestamping') ];
		package: 'Cosmos-Data-Tests'
			with: [ spec requires: #('Cosmos-Tests' 'Cosmos-Data' 'Cosmos-UserStoryTests') ];
		package: 'Cosmos-Triggers-Tests'
			with: [ spec requires: #('Cosmos-Tests' 'Cosmos-Triggers' 'Cosmos-UserStoryTests') ];
		package: 'Cosmos-Commands-Tests'
			with: [ spec requires: #('Cosmos-Tests' 'Cosmos-Commands' 'Cosmos-UserStoryTests') ];
		package: 'Cosmos-Actions-Tests'
			with: [ spec requires: #('Cosmos-Tests' 'Cosmos-Actions' 'Cosmos-UserStoryTests') ];
		package: 'Cosmos-PeriodicalScheduler-Tests'
			with: [ spec requires: #('Cosmos-PeriodicalScheduler-Core') ];
		package: 'Cosmos-ActionEvaluator-Tests'
			with: [ spec requires: #('Cosmos-ActionEvaluator-Core') ].

	spec
		group: 'Cosmos-Model-Tests'
		with:
			#('Cosmos-Tests' 'Cosmos-UserStoryTests' 'Cosmos-Identifier-Tests' 'Cosmos-Metadata-Tests' 'Cosmos-Timestamping-Tests' 'Cosmos-Data-Tests' 'Cosmos-Triggers-Tests' 'Cosmos-Commands-Tests' 'Cosmos-Actions-Tests' 'Cosmos-PeriodicalScheduler-Tests' 'Cosmos-ActionEvaluator-Tests')
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
