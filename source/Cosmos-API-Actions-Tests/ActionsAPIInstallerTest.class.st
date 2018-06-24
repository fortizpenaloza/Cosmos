"
An ActionsAPIInstallerTest is a test class for testing the behavior of ActionsAPIInstaller
"
Class {
	#name : #ActionsAPIInstallerTest,
	#superclass : #TestCase,
	#category : #'Cosmos-API-Actions-Tests'
}

{ #category : #tests }
ActionsAPIInstallerTest >> testInstallation [

	| teapot |

	teapot := Teapot on.
	(ActionsAPIInstaller toInstallOn: teapot workingWith: self) install.
	self assert: teapot routes size equals: 3
]
