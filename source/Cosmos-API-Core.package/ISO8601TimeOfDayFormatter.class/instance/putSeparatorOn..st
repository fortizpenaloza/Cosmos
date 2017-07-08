private-formatting
putSeparatorOn: aStream

	separator withContentDo: [ :configuredSeparator | aStream nextPut: configuredSeparator ]