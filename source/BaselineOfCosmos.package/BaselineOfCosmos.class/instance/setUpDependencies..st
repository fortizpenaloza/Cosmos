private-baselines
setUpDependencies: spec

	spec
		baseline: 'Kepler'
		with: [ spec
				repository: 'github://ba-st/Kepler:master/source';
				loads: #('Development') ].
	
	spec
		configuration: 'Teapot'
		with: [ spec
				versionString: #stable;
				repository: 'http://smalltalkhub.com/mc/zeroflag/Teapot/main/' ].
			
	spec
		configuration: 'Roassal2'
    		with: [  spec
				versionString: #development;
				repository: 'http://smalltalkhub.com/mc/ObjectProfile/Roassal2/main' ]