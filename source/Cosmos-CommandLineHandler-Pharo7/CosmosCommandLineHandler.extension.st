Extension { #name : #CosmosCommandLineHandler }

{ #category : #'*Cosmos-CommandLineHandler-Pharo7' }
CosmosCommandLineHandler >> periodicalScheduler [

	^ PeriodicalScheduler usingDefaultScheduler
]
