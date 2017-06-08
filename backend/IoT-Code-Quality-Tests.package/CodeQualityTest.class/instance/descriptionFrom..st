accessing
descriptionFrom: ruleCheckingResult

	| writeStream |

	writeStream := WriteStream on: String new.
	ruleCheckingResult
		classesAndSelectorsDo: [ :class :selector | 
			writeStream
				nextPutAll: class asString;
				nextPutAll: '->';
				nextPutAll: selector name;
				yourself ].
			
	^ '<1s> (<2p>): <3s>'
		expandMacrosWith: ruleCheckingResult label
		with: ruleCheckingResult problemCount
		with: writeStream contents