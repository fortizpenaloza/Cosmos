as yet unclassified
action

	^ Action
		named: 'List DNS records'
		createdOn: (September sixth , 2015) atNoon
		toEvaluate:
			(ZnRequest empty
				requestLine:
					(ZnRequestLine empty
						method: #GET;
						uri: 'www.google.com' asZnUrl;
						version: ZnConstants defaultHTTPVersion;
						yourself);
				yourself)