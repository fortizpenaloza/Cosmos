installing
installedSystem

	| timeSource builder system |

	builder := CompositeSystemBuilder new.
	timeSource := SystemTimeSource new.
	builder
		add: (TimeSystem using: timeSource);
		add: EventNotificationSystem new;
		add: DataManagementSystem new;
		add: TriggerManagementSystem new;
		add: ActionManagementSystem new;
		add: CommandManagementSystem new;
		yourself.

	system := builder build.
	system startUp.
	^ system