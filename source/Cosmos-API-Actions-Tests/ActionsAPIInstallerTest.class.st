"
An ActionsAPIInstallerTest is a test class for testing the behavior of ActionsAPIInstaller
"
Class {
	#name : #ActionsAPIInstallerTest,
	#superclass : #TestCase,
	#category : #'Cosmos-API-Actions-Tests'
}

{ #category : #history }
ActionsAPIInstallerTest class >> lastStoredRun [
	^ ((Dictionary new) add: (#timeStamp->(DateAndTime basicNew instVarAt: 1 put: 6510; instVarAt: 2 put: (Duration seconds: -10800 nanoSeconds: 0); instVarAt: 3 put: 2458339; instVarAt: 4 put: 624772000; yourself)); add: (#passed->((Set new) add: #testInstallation; yourself)); add: (#failures->((Set new))); add: (#errors->((Set new))); yourself)
]

{ #category : #tests }
ActionsAPIInstallerTest >> testInstallation [

	| teapot |

	teapot := Teapot on.
	(ActionsAPIInstaller toInstallOn: teapot workingWith: self) install.
	self assert: teapot routes size equals: 4
]
