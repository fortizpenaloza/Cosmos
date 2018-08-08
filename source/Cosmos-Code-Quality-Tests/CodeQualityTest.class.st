Class {
	#name : #CodeQualityTest,
	#superclass : #TestCase,
	#category : 'Cosmos-Code-Quality-Tests'
}

{ #category : #history }
CodeQualityTest class >> lastStoredRun [
	^ ((Dictionary new) add: (#timeStamp->(DateAndTime basicNew instVarAt: 1 put: 6510; instVarAt: 2 put: (Duration seconds: -10800 nanoSeconds: 0); instVarAt: 3 put: 2458339; instVarAt: 4 put: 644624000; yourself)); add: (#passed->((Set new) add: #testMessageSentToSelfButNotImplemented; add: #testMessageImplementedButNotSent; add: #testSubclassReponsibilityImplementedInLeafClases; add: #testInstaceVariableNeitherReadNorWritten; add: #testMessageSentButNotImplemented; yourself)); add: (#failures->((Set new) add: #testMessagesMustBeCategorized; yourself)); add: (#errors->((Set new))); yourself)
]

{ #category : #'tests support' }
CodeQualityTest >> assertThereIsNoProblemsRunning: aRule [

	| ruleCheckingResult |

	ruleCheckingResult := self checkingResultFor: aRule.
	self assert: ruleCheckingResult problemCount = 0 description: (self descriptionFrom: ruleCheckingResult)
]

{ #category : #'tests support' }
CodeQualityTest >> checkingResultFor: aRule [

	^ (RBSmalllintChecker
		runRule: aRule
		onEnvironment: (RBPackageEnvironment packages: self packagesToBeChecked)) result
]

{ #category : #accessing }
CodeQualityTest >> descriptionFrom: ruleCheckingResult [

	| writeStream |

	writeStream := WriteStream on: String new. 
	ruleCheckingResult
		classesAndSelectorsDo: [ :class :selector | 
			writeStream
				nextPutAll: class asString;
				nextPutAll: '->';
				nextPutAll: selector asString;
				yourself ].
			
	^ '<1s> (<2p>): <3s>'
		expandMacrosWith: ruleCheckingResult label
		with: ruleCheckingResult problemCount
		with: writeStream contents
]

{ #category : #accessing }
CodeQualityTest >> packagesToBeChecked [

	^ RPackage organizer packages select: [ :package | #('Cosmos-' 'Kepler-') anySatisfy: [ :prefix | package name beginsWith: prefix ] ]
]

{ #category : #tests }
CodeQualityTest >> testInstaceVariableNeitherReadNorWritten [

	self assertThereIsNoProblemsRunning: RBOnlyReadOrWrittenVariableRule new
]

{ #category : #tests }
CodeQualityTest >> testMessageImplementedButNotSent [

	self assertThereIsNoProblemsRunning: RBImplementedNotSentRule new
]

{ #category : #tests }
CodeQualityTest >> testMessageSentButNotImplemented [

	self assertThereIsNoProblemsRunning: RBSentNotImplementedRule new
]

{ #category : #tests }
CodeQualityTest >> testMessageSentToSelfButNotImplemented [

	self assertThereIsNoProblemsRunning: RBSelfSentNotImplementedRule new
]

{ #category : #tests }
CodeQualityTest >> testMessagesMustBeCategorized [

	self assertThereIsNoProblemsRunning: RBUnclassifiedMethodsRule new
]

{ #category : #tests }
CodeQualityTest >> testSubclassReponsibilityImplementedInLeafClases [

	self assertThereIsNoProblemsRunning: RBSubclassResponsibilityNotDefinedRule new
]
