accessing
action

	^ Action
		named: 'List DNS records'
		createdOn: (September sixth , 2015) atNoon
		toEvaluate:
			(ZnRequest new
				requestLine:
					(ZnRequestLine empty
						method: #GET;
						uri: 'https://api.cloudflare.com/client/v4/zones/77527abc25e3d9004fd943209c925e4e/dns_records' asZnUrl;
						version: ZnConstants defaultHTTPVersion;
						yourself);
				yourself)