Class {
	#name : #DataAPIInstallerTest,
	#superclass : #TestCase,
	#category : #'Cosmos-API-Data-Tests'
}

{ #category : #tests }
DataAPIInstallerTest >> testInstallation [

	| teapot |

	teapot := Teapot on.
	(DataAPIInstaller toInstallOn: teapot workingWith: self) install.

	self assert: teapot routes size equals: 4
]
