testing
isSatisfied

	self flag: 'viene bien pero esta mal'.

	^ conditions allSatisfy: [:condition | condition isSatisfied]