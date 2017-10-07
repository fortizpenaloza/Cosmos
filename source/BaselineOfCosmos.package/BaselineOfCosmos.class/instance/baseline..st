baselines
baseline: spec

	<baseline>
	spec
		for: #common
		do: [ self setUpDependencies: spec.
			spec
				package: 'Cosmos-Data-Core' with: [ spec requires: #('Buoy' 'Kepler') ];
				package: 'Cosmos-ConditionalTrigger-Core' with: [ spec requires: #('Buoy' 'Kepler') ];
				package: 'Cosmos-Commands-Core' with: [ spec requires: #('Kepler') ];
				package: 'Cosmos-Actions-Core' with: [ spec requires: #('Kepler') ];
				package: 'Cosmos-PeriodicalScheduler-Core'.

			spec
				package: 'Cosmos-API-Core' with: [ spec requires: 'Teapot' ];
				package: 'Cosmos-Data-API-Core' with: [ spec requires: #('Cosmos-API-Core' 'Cosmos-Data-Core') ];
				package: 'Cosmos-Commands-API-Core' with: [ spec requires: #('Cosmos-API-Core' 'Cosmos-Commands-Core') ];
				package: 'Cosmos-Actions-API-Core' with: [ spec requires: #('Cosmos-API-Core' 'Cosmos-Actions-Core')].

			spec
				package: 'Cosmos-Tests';
				package: 'Cosmos-UserStoryTests' with: [ spec requires: #('Cosmos-Data-Core' 'Cosmos-Commands-Core' 'Cosmos-ConditionalTrigger-Core') ];
				package: 'Cosmos-Data-Tests' with: [ spec requires: #('Cosmos-Tests' 'Cosmos-Data-Core' 'Cosmos-UserStoryTests') ];
				package: 'Cosmos-ConditionalTrigger-Tests'
					with: [ spec requires: #('Cosmos-Tests' 'Cosmos-ConditionalTrigger-Core' 'Cosmos-UserStoryTests') ];
				package: 'Cosmos-Commands-Tests' with: [ spec requires: #('Cosmos-Tests' 'Cosmos-Commands-Core' 'Cosmos-UserStoryTests') ];
				package: 'Cosmos-Actions-Tests' with: [ spec requires: #('Cosmos-Tests' 'Cosmos-Actions-Core' 'Cosmos-UserStoryTests') ];
				package: 'Cosmos-PeriodicalScheduler-Tests' with: [ spec requires: #('Cosmos-PeriodicalScheduler-Core') ].

			spec
				package: 'Cosmos-API-Tests' with: [ spec requires: #('Cosmos-API-Core' 'Cosmos-UserStoryTests') ];
				package: 'Cosmos-Data-API-Tests' with: [ spec requires: #('Cosmos-Data-API-Core' 'Cosmos-UserStoryTests') ];
				package: 'Cosmos-Commands-API-Tests' with: [ spec requires: #('Cosmos-Commands-API-Core' 'Cosmos-UserStoryTests') ];
				package: 'Cosmos-Actions-API-Tests' with: [ spec requires: #('Cosmos-Actions-API-Core' 'Cosmos-UserStoryTests')].
			
			spec
				package: 'Cosmos-Code-Quality-Tests'.

			spec
				group: 'Deployment'
					with:
					#('Cosmos-Data-Core' 'Cosmos-ConditionalTrigger-Core' 'Cosmos-Commands-Core' 'Cosmos-Actions-Core' 'Cosmos-PeriodicalScheduler-Core' 'Cosmos-API-Core' 'Cosmos-Data-API-Core' 'Cosmos-Commands-API-Core');
				group: 'Tests'
					with:
					#('Cosmos-Tests' 'Cosmos-UserStoryTests' 'Cosmos-Data-Tests' 'Cosmos-ConditionalTrigger-Tests' 'Cosmos-Commands-Tests' 'Cosmos-Actions-Tests' 'Cosmos-PeriodicalScheduler-Tests' 'Cosmos-API-Tests' 'Cosmos-Data-API-Tests' 'Cosmos-Commands-API-Tests' 'Cosmos-Code-Quality-Tests');
				group: 'Development' with: #('Deployment' 'Tests');
				group: 'default' with: #('Deployment').
			spec postLoadDoIt: #postload:package: ]