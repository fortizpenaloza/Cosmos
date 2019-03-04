Class {
	#name : #ActionManagementSystemUserStoryTest,
	#superclass : #SystemBasedUserStoryTest,
	#category : #'Cosmos-Actions-Tests'
}

{ #category : #accessing }
ActionManagementSystemUserStoryTest >> octoberFirstOf2014AtNoon [

	^ (October first , 2014) atNoon
]

{ #category : #accessing }
ActionManagementSystemUserStoryTest >> sendTextMessageToFran [

	^ Action
		named: 'Send text message to Fran'
		evaluating: [ "do nothing" ]
]

{ #category : #accessing }
ActionManagementSystemUserStoryTest >> sendYOToFran [

	^ Action
		named: 'Send YO to Fran'
		evaluating: [ "do nothing" ]
]

{ #category : #'private - running' }
ActionManagementSystemUserStoryTest >> setUpRequirements [

	self
		registerSubsystem: (TimeSystem using: (FixedTimeSource on: self octoberFirstOf2014AtNoon));
		registerSubsystem: MetadataSystem new;
		registerSubsystem: (IdentifierSystem using: self identifierProvider);
		registerSubsystem: (TimestampingSystem new);
		registerSubsystem: ActionManagementSystem new
]

{ #category : #tests }
ActionManagementSystemUserStoryTest >> testAccessing [ 
	
	self assert: self actionManagementSystem name equals: 'Action Management'
	
]

{ #category : #tests }
ActionManagementSystemUserStoryTest >> testDeregistration [

	| action |

	action := self sendYOToFran.

	self actionManagementSystem register: action.
	self
		assertCollection: self actionManagementSystem actions
		hasSameElements: {action}.

	self actionManagementSystem deregister: action.
	self assert: self actionManagementSystem actions isEmpty
]

{ #category : #tests }
ActionManagementSystemUserStoryTest >> testDeregistrationFailsIfNotExists [

	self
		should: [ self actionManagementSystem deregister: self sendYOToFran ]
		raise: NotFound
]

{ #category : #tests }
ActionManagementSystemUserStoryTest >> testMetadataRegistrationOnActionRegistration [

	| action metadata |

	action := self sendYOToFran.

	self assert: (self metadataSystem metadataFor: action) isEmpty.
	self actionManagementSystem register: action.

	metadata := self metadataSystem metadataFor: action.
	self
		assert: metadata size equals: 2;
		assert: metadata
			equals:
			{(Metadata 
				attaching: self currentIdentifier 
				as: #identifier 
				of: action).
			(Metadata 
				attaching: self octoberFirstOf2014AtNoon 
				as: #update_timestamp 
				of: action)} asOrderedCollection
]

{ #category : #tests }
ActionManagementSystemUserStoryTest >> testQueringRegisteredActions [

	| action anotherAction |

	action := self sendYOToFran.
	self actionManagementSystem register: action.

	anotherAction := self sendTextMessageToFran.
	self actionManagementSystem register: anotherAction.

	self
		assert: self actionManagementSystem actions
		hasSameElementsInOrderAs:
			{action.
			anotherAction}
]

{ #category : #tests }
ActionManagementSystemUserStoryTest >> testRegistration [

	self assert: self actionManagementSystem actions isEmpty.
	
	self actionManagementSystem register: self sendYOToFran.
	self
		withTheOnlyOneIn: self actionManagementSystem actions
		do: [ :action | self assert: action name equals: 'Send YO to Fran' ]
]

{ #category : #tests }
ActionManagementSystemUserStoryTest >> testRegistrationFailsWhenActionAlreadyExists [

	| action |

	action := self sendYOToFran.
	self actionManagementSystem register: action.
	self
		should: [ self actionManagementSystem register: action ]
		raise: ConflictingObjectFound
		withMessageText: 'An action with that name already exists in system'
]
