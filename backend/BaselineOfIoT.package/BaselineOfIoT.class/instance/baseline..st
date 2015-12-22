baselines
baseline: spec
	<baseline>
	
	spec
		for: #common
		do:  [ 
		
			spec baseline: 'Chalten' with: [
				spec
					loads: #('Core');
					repository: 'github://mtaborda/chalten:master/repository' ].
			spec
				package: 'IoT-Core' with: [ spec requires: 'Chalten' ];
				package: 'IoT-Tests' with: [ spec requires: 'IoT-Core' ].
			spec
				group: 'Development' with: #('IoT-Core' 'IoT-Tests');
				group: 'Deployment' with: #('IoT-Core');
				group: 'default' with: #('Deployment') ]
