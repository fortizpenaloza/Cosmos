Extension { #name : #CosmosCommandLineHandler }

{ #category : #'*Cosmos-CommandLineHandler-Pharo6' }
CosmosCommandLineHandler >> periodicalScheduler [

	^ PeriodicalScheduler workingWith: DelaySpinScheduler new
]
