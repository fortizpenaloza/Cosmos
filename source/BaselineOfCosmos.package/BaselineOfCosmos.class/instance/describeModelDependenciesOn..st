private-baselines
describeModelDependenciesOn: spec

	spec
		package: 'Cosmos-Data-Core'
			with: [ spec requires: #('Kepler') ];
		package: 'Cosmos-Triggers-Core'
			with: [ spec requires: #('Kepler') ];
		package: 'Cosmos-Commands-Core'
			with: [ spec requires: #('Kepler') ];
		package: 'Cosmos-Actions-Core' with: [ spec requires: #('Kepler') ];
		package: 'Cosmos-PeriodicalScheduler-Core';
		package: 'Cosmos-ActionEvaluator-Core'