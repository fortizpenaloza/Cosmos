Class {
	#name : #CodeQualityTest,
	#superclass : #TestCase,
	#category : 'Cosmos-Code-Quality-Tests'
}

{ #category : #'tests support' }
CodeQualityTest >> assertThereWasNoIssuesRunning: aRule onDeclaredPackagesExcluding: aClassSet [

	| ruleCheckingResult |

	ruleCheckingResult := self
		resultAfterRunning: aRule
		on: self packagesToBeChecked 
		excluding: aClassSet.
		
	self
		assert: ruleCheckingResult isEmpty
		description: (self descriptionFrom: ruleCheckingResult)
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

	^ RPackage organizer packages
		select: [ :package | #('Cosmos-') anySatisfy: [ :prefix | package name beginsWith: prefix ] ]
]

{ #category : #'tests support' }
CodeQualityTest >> resultAfterRunning: aRule on: aPackageSet excluding: aClassSet [

	| allClassesWithoutExcluded |

	allClassesWithoutExcluded := (aPackageSet flatCollect: #classes)
		difference: aClassSet.

	^ (RBSmalllintChecker
		runRule: aRule
		onEnvironment:
			(RBPackageEnvironment packages: aPackageSet)
				& (RBClassEnvironment classes: allClassesWithoutExcluded)) result
]

{ #category : #tests }
CodeQualityTest >> testInstaceVariableNeitherReadNorWritten [

	self
		assertThereWasNoIssuesRunning: RBOnlyReadOrWrittenVariableRule new
		onDeclaredPackagesExcluding: #()
]

{ #category : #tests }
CodeQualityTest >> testMessageImplementedButNotSent [

	self
		assertThereWasNoIssuesRunning: RBImplementedNotSentRule new asRBRule
		onDeclaredPackagesExcluding: ResourceRESTfulControllerSpecification subclasses
]

{ #category : #tests }
CodeQualityTest >> testMessageSentButNotImplemented [

	self
		assertThereWasNoIssuesRunning: RBSentNotImplementedRule new asRBRule
		onDeclaredPackagesExcluding:
			{TriggersRESTfulControllerTest.
			DataStreamsRESTfulControllerTest.
			CommandsRESTfulControllerTest.
			ActionsRESTfulControllerTest }
]

{ #category : #tests }
CodeQualityTest >> testMessageSentToSelfButNotImplemented [

	self
		assertThereWasNoIssuesRunning: RBSelfSentNotImplementedRule new asRBRule
		onDeclaredPackagesExcluding: #()
]

{ #category : #tests }
CodeQualityTest >> testMessagesMustBeCategorized [

	self
		assertThereWasNoIssuesRunning: RBUnclassifiedMethodsRule new asRBRule
		onDeclaredPackagesExcluding: #()
]

{ #category : #tests }
CodeQualityTest >> testSubclassReponsibilityImplementedInLeafClases [

	self
		assertThereWasNoIssuesRunning: RBSubclassResponsibilityNotDefinedRule new asRBRule
		onDeclaredPackagesExcluding: #()
]
