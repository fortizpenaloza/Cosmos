initialize-release
testRegistration

	| interface response |

	interface := ActionsAPI
		workingWith: (ActionsAPIContext workingWith: rootSystem).
		
	self assert: self actionManagementSystem actions isEmpty.

	response := interface
		registerFrom:
			'{
		"name" : "List DNS records",
		"request" : { 
			"request_line" : { 
				"method" : "GET",
				"URL" : "https://api.cloudflare.com/client/v4/zones/77527abc25e3d9004fd943209c925e4e/dns_records",
				"version" : "HTTP/1.1"
			},
		"headers" : [
			{
				"key" : "X-Auth-Email",
				"value" : "patchinko@gmail.com"
			},
			{
				"key" : "X-Auth-Key",
				"value" : "93b0b7a99ad1fc123d0d2b6508849db7e6414"
			}
		]
	}
}'.

	self
		assert: response code equals: 201;
		assert: (response headers includesKey: 'Location').
		
	self
		withTheOnlyOneIn: self actionManagementSystem actions
		do: [ :action | self assert: action name equals: 'List DNS records';
				assert: action creationDateTime equals: self timeSystem dateTime ]