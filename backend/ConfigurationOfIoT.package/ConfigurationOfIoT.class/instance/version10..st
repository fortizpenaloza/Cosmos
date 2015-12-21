versions
version10: spec
	<version: '1.0'>
	
	spec for: #common do: [ 
		spec blessing: #release.
		spec description: '- IoT release for 5.x images'.
		spec author: 'fortizpenaloza'.
		spec
			baseline: 'IoT'
			with: [ spec repository: 'github://fortizpenaloza/IoT:master/backend' ].
		spec import: 'IoT'. ]