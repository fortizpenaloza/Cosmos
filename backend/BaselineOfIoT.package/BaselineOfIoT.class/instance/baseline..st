baselines
baseline: spec
	<baseline>
	
	spec
		for: #common
		do:
			[ spec
				package: 'IoT-Core';
				package: 'IoT-Tests' with: [ spec requires: 'IoT-Core' ].
			spec
				group: 'Development' with: #('IoT-Core' 'IoT-Tests');
				group: 'Deployment' with: #('IoT-Core');
				group: 'default' with: #('Deployment') ]