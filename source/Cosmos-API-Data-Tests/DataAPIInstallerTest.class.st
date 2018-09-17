Class {
	#name : #DataAPIInstallerTest,
	#superclass : #TestCase,
	#category : #'Cosmos-API-Data-Tests'
}

{ #category : #tests }
DataAPIInstallerTest >> testInstallation [

	| teapot |

	teapot := Teapot on.

	(ReflectiveRoutesConfigurator appliedTo: teapot)
		addRoutesOf: (DataWebService workingWith: self).

	self assert: teapot routes size equals: 6
]
