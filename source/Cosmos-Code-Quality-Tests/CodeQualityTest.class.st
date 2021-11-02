Class {
	#name : #CodeQualityTest,
	#superclass : #TestCase,
	#category : #'Cosmos-Code-Quality-Tests'
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

	| formatter |

	formatter := CollectionFormatter separatingWith: Character cr
		             applyingToEach: [ :element | 
		             '<1s> on [<2s>]' expandMacrosWith: element title with: element entity name ].

	^ formatter format: ruleCheckingResult
]

{ #category : #accessing }
CodeQualityTest >> packagesToBeChecked [

	^ RPackage organizer packages
		select: [ :package | #('Cosmos-') anySatisfy: [ :prefix | package name beginsWith: prefix ] ]
]

{ #category : #'tests support' }
CodeQualityTest >> resultAfterRunning: aRule on: aPackageSet excluding: aClassSet [

	| runner environment allClassesWithoutExcluded |

	allClassesWithoutExcluded := ( aPackageSet flatCollect: #classes ) difference: aClassSet.

	environment := ( RBPackageEnvironment packages: aPackageSet )
	               & ( RBClassEnvironment classes: allClassesWithoutExcluded ).

	runner := ReSmalllintChecker new.
	runner
		rule: { aRule };
		environment: environment;
		run.

	^ runner criticsOf: aRule
]

{ #category : #tests }
CodeQualityTest >> testInstaceVariableNeitherReadNorWritten [

	self
		assertThereWasNoIssuesRunning: ReIvarNeitherReadNorWrittenRule new
		onDeclaredPackagesExcluding: #()
]

{ #category : #tests }
CodeQualityTest >> testMessageImplementedButNotSent [

	self
		assertThereWasNoIssuesRunning: ReImplementedNotSentRule new
		onDeclaredPackagesExcluding:
			{ActionEvaluationsRESTfulController.
			DataPointsRESTfulController.
			ActionsRESTfulController.
			DataStreamsRESTfulController.
			TriggersRESTfulController.
			CommandsRESTfulController.
			TriggerManagementSystem}
]

{ #category : #tests }
CodeQualityTest >> testMessageSentButNotImplemented [

	self
		assertThereWasNoIssuesRunning: ReSentNotImplementedRule new
		onDeclaredPackagesExcluding:
			{TriggersRESTfulControllerTest.
			DataStreamsRESTfulControllerTest.
			CommandsRESTfulControllerTest.
			ActionsRESTfulControllerTest }
]

{ #category : #tests }
CodeQualityTest >> testMessageSentToSelfButNotImplemented [

	self
		assertThereWasNoIssuesRunning: ReSelfSentNotImplementedRule new
		onDeclaredPackagesExcluding: #()
]

{ #category : #tests }
CodeQualityTest >> testMessagesMustBeCategorized [

	self
		assertThereWasNoIssuesRunning: ReUnclassifiedMethodsRule new
		onDeclaredPackagesExcluding: #()
]

{ #category : #tests }
CodeQualityTest >> testSubclassReponsibilityImplementedInLeafClases [

	self
		assertThereWasNoIssuesRunning: ReSubclassResponsibilityNotDefinedRule new
		onDeclaredPackagesExcluding: #()
]
