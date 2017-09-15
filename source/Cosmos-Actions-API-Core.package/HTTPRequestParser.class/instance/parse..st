parsing
parse: aRawRequest

	| requestLine headers |

	requestLine := self parse: #request_line from: aRawRequest with: self requestLineParser.
	headers := self parse: #headers from: aRawRequest with: self headersParser.

	^ ZnRequest empty
		requestLine: requestLine;
		headers: headers;
		yourself