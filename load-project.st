Iceberg remoteTypeSelector: #httpsUrl.

Metacello new
	baseline: 'Cosmos';
	repository: ('github://iot-uca/back-end:<1s>/source' expandMacrosWith: (Smalltalk os environment at: 'SOURCE_BRANCH' ifAbsent: ['master']));
	load: 'Deployment'.

SmalltalkImage current
	closeSourceFiles;
	openSourceFiles;
	snapshot: true andQuit: true. 

