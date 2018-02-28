API
triggers

	^ ZnResponse
		ok: (ZnEntity json: (triggersMapping value: self triggerManagementSystem triggers))