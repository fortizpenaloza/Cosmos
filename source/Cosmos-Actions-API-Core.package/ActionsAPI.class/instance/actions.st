API
actions

	^ ZnResponse
		ok: (ZnEntity json: (actionsMapping value: self actionManagementSystem actions))