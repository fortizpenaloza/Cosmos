baselines
baseline: spec

	<baseline>
	spec
		for: #common
		do: [ self setUpDependencies: spec.
			self
				describeModelDependenciesOn: spec;
				describeAPIDependeciesOn: spec.

			spec
				package: 'Cosmos-Tests';
				package: 'Cosmos-UserStoryTests'
					with: [ spec requires: #('Cosmos-Data-Core' 'Cosmos-Commands-Core' 'Cosmos-Triggers-Core') ];
				package: 'Cosmos-Data-Tests'
					with: [ spec requires: #('Cosmos-Tests' 'Cosmos-Data-Core' 'Cosmos-UserStoryTests') ];
				package: 'Cosmos-Triggers-Tests'
					with: [ spec requires: #('Cosmos-Tests' 'Cosmos-Triggers-Core' 'Cosmos-UserStoryTests') ];
				package: 'Cosmos-Commands-Tests'
					with: [ spec requires: #('Cosmos-Tests' 'Cosmos-Commands-Core' 'Cosmos-UserStoryTests') ];
				package: 'Cosmos-Actions-Tests'
					with: [ spec requires: #('Cosmos-Tests' 'Cosmos-Actions-Core' 'Cosmos-UserStoryTests') ];
				package: 'Cosmos-PeriodicalScheduler-Tests' with: [ spec requires: #('Cosmos-PeriodicalScheduler-Core') ];
				package: 'Cosmos-ActionEvaluator-Tests' with: [ spec requires: #('Cosmos-ActionEvaluator-Core') ].

			spec
				package: 'Cosmos-API-Tests' with: [ spec requires: #('Cosmos-API-Core' 'Cosmos-UserStoryTests') ];
				package: 'Cosmos-Data-API-Tests'
					with: [ spec requires: #('Cosmos-Data-API-Core' 'Cosmos-UserStoryTests') ];
				package: 'Cosmos-Commands-API-Tests'
					with: [ spec requires: #('Cosmos-Commands-API-Core' 'Cosmos-UserStoryTests') ];
				package: 'Cosmos-Actions-API-Tests'
					with: [ spec requires: #('Cosmos-Actions-API-Core' 'Cosmos-UserStoryTests') ];
				package: 'Cosmos-Triggers-API-Tests'
					with: [ spec requires: #('Cosmos-Triggers-API-Core' 'Cosmos-UserStoryTests') ].

			spec package: 'Cosmos-Code-Quality-Tests'.

			spec package: 'Cosmos' with: [ spec requires: #('Teapot' 'Kepler' 'Cosmos-Data-API-Core') ].

			spec package: 'Cosmos-Tools' with: [ spec requires: #('Roassal2') ].

			spec
				group: 'Deployment'
					with:
					#('Cosmos-Data-Core' 'Cosmos-Triggers-Core' 'Cosmos-Commands-Core' 'Cosmos-Actions-Core' 'Cosmos-PeriodicalScheduler-Core' 'Cosmos-ActionEvaluator-Core' 'Cosmos-API-Core' 'Cosmos-Data-API-Core' 'Cosmos-Commands-API-Core' 'Cosmos-Actions-API-Core' 'Cosmos-Triggers-API-Core' 'Cosmos');
				group: 'Tests'
					with:
					#('Cosmos-Tests' 'Cosmos-UserStoryTests' 'Cosmos-Data-Tests' 'Cosmos-Triggers-Tests' 'Cosmos-Commands-Tests' 'Cosmos-Actions-Tests' 'Cosmos-PeriodicalScheduler-Tests' 'Cosmos-ActionEvaluator-Tests' 'Cosmos-API-Tests' 'Cosmos-Data-API-Tests' 'Cosmos-Commands-API-Tests' 'Cosmos-Actions-API-Tests' 'Cosmos-Triggers-API-Tests' 'Cosmos-Code-Quality-Tests');
				group: 'Tools' with: #('Cosmos-Tools');
				group: 'CI' with: #('Deployment' 'Tests');
				group: 'Development' with: #('CI' 'Tools');
				group: 'default' with: #('Deployment').
			spec postLoadDoIt: #postload:package: ]