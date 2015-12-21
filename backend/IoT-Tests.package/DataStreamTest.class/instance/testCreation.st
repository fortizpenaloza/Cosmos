test
testCreation

	| dataStream identifier |

	identifier := '1'.
	dataStream := DataStream identifiedBy: identifier.
	
	self assert: dataStream identifier equals: identifier.
	self assert: dataStream dataPoints isEmpty