formatting - private
putSeparatorOn: aStream

	separator withContentDo: [ :configuredSeparator | aStream nextPut: configuredSeparator ]