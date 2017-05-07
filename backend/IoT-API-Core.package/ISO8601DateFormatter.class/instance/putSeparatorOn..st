formatting - private
putSeparatorOn: aStream

	separator
		ifBound: [ :configuredSeparator | aStream nextPut: configuredSeparator ]
		ifNot: [  ]	"do nothing"