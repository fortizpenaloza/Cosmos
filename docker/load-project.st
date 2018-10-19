Iceberg remoteTypeSelector: #httpsUrl.

Metacello new
	baseline: 'Cosmos';
	repository: 'github://iot-uca/back-end:master/source';
	load: 'Deployment'.

SmalltalkImage current
	closeSourceFiles;
	openSourceFiles;
	snapshot: true andQuit: true. 

