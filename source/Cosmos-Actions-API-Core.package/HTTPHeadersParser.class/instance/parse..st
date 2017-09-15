parsing
parse: rawHeaders

	^ rawHeaders
		inject: ZnHeaders new
		into: [ :headers :rawHeader | 
			headers
				at: (rawHeader at: #key) put: (rawHeader at: #value);
				yourself ]