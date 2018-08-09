"
A TriggersAPIInstallerTest is a test class for testing the behavior of TriggersAPIInstaller
"
Class {
	#name : #TriggersAPIInstallerTest,
	#superclass : #TestCase,
	#category : #'Cosmos-API-Triggers-Tests'
}

{ #category : #history }
TriggersAPIInstallerTest class >> lastStoredRun [
	^ ((Dictionary new) add: (#timeStamp->(DateAndTime basicNew instVarAt: 1 put: 6510; instVarAt: 2 put: (Duration seconds: -10800 nanoSeconds: 0); instVarAt: 3 put: 2458339; instVarAt: 4 put: 645530000; yourself)); add: (#passed->((Set new) add: #testInstallation; yourself)); add: (#failures->((Set new))); add: (#errors->((Set new))); yourself)
]

{ #category : #tests }
TriggersAPIInstallerTest >> testInstallation [

	| teapot |

	teapot := Teapot on.
	(TriggersAPIInstaller toInstallOn: teapot workingWith: self) install.

	self assert: teapot routes size equals: 3
]
