private-baselines
setUpDependencies: spec

	spec
		baseline: 'Buoy'
		with: [ spec
				repository: 'github://ba-st/Buoy:master/source';
				loads: #('Deployment') ].
	spec
		baseline: 'Chalten'
		with: [ spec
				repository: 'github://ba-st/chalten:v6.0.0/repository';
				loads: #('Core') ].
	spec
		baseline: 'Kepler'
		with: [ spec
				repository: 'github://iot-uca/Kepler:master/source';
				loads: #('Development') ].
	spec
		configuration: 'Teapot'
		with: [ spec
				versionString: #stable;
				repository: 'http://smalltalkhub.com/mc/zeroflag/Teapot/main/' ].
			
	spec
		configuration: 'Roassal2'
    		with: [  spec
				versionString: 'bleedingEdge';
				repository: 'http://smalltalkhub.com/mc/ObjectProfile/Roassal2/main' ]