enumerating
ifSatisfiedDo: aBlockClosure 
	
	condition isSatisfied ifTrue: [ aBlockClosure value: action ]