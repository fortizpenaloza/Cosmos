parsing
parse: rawRequestLine

	^ ZnRequestLine empty
		method: (rawRequestLine at: #method);
		uri: (rawRequestLine at: #URL) asZnUrl;
		version: (rawRequestLine at: #version);
		yourself 