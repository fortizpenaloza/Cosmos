Class {
	#name : #CodeQualityTest,
	#superclass : #TestCase,
	#category : 'Cosmos-Code-Quality-Tests'
}

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
