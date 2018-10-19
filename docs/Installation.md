# Installation

## Basic Installation

You can load **Cosmos** evaluating:
```smalltalk
Metacello new
	baseline: 'Cosmos';
	repository: 'github://iot-uca/Cosmos:master/source';
	load.
```
>  Change `master` to some released version if you want a pinned version

## Using as dependency

In order to include **Cosmos** as part of your project, you should reference the package in your product baseline:

```smalltalk
setUpDependencies: spec

	spec
		baseline: 'Cosmos'
			with: [ spec
				repository: 'github://iot-uca/Cosmos:v{XX}/source';
				loads: #('Deployment') ];
		import: 'Cosmos'.
```
> Replace `{XX}` with the version you want to depend on

```smalltalk
baseline: spec

	<baseline>
	spec
		for: #common
		do: [ self setUpDependencies: spec.
			spec package: 'My-Package' with: [ spec requires: #('Cosmos') ] ]
