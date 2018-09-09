"
A TriggersAPIInstallerTest is a test class for testing the behavior of TriggersAPIInstaller
"
Class {
	#name : #TriggersAPIInstallerTest,
	#superclass : #TestCase,
	#category : #'Cosmos-API-Triggers-Tests'
}

{ #category : #tests }
TriggersAPIInstallerTest >> testInstallation [

	| teapot |

	teapot := Teapot on.
	(TriggersAPIInstaller toInstallOn: teapot workingWith: self) install.

	self assert: teapot routes size equals: 4
]
