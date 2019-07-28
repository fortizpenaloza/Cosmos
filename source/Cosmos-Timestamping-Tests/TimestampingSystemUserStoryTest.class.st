Class {
	#name : #TimestampingSystemUserStoryTest,
	#superclass : #SystemBasedUserStoryTest,
	#category : #'Cosmos-Timestamping-Tests'
}

{ #category : #'private - running' }
TimestampingSystemUserStoryTest >> setUpRequirements [

	self
		registerSubsystem: (TimeSystem using: (FixedTimeSource on: self systemDateTime));
		registerSubsystem: MetadataSystem new;
		registerSubsystem: TimestampingSystem new
]

{ #category : #'private - accessing' }
TimestampingSystemUserStoryTest >> systemDateTime [

	^ DateTime 
		date: October first , 2014 
		timeOfDay: TimeOfDay noon 
		zone: TimeZones buenosAires
]

{ #category : #tests }
TimestampingSystemUserStoryTest >> testAccessing [ 
	
	self assert: self timestampingSystem name equals: 'Timestamping'
	
]

{ #category : #tests }
TimestampingSystemUserStoryTest >> testQueryingTimestampFailsIfNotRegistered [

	self
		should: [ self timestampingSystem lastModificationOf: #notRegisteredObject ]
		raise: ObjectNotFound
		withMessageText: 'Data describing #update_timestamp aspect of #notRegisteredObject not found'
]

{ #category : #tests }
TimestampingSystemUserStoryTest >> testTimestampRegistration [

	self timestampingSystem registerModificationFor: 1.
	self assert: (self timestampingSystem lastModificationOf: 1) equals: self systemDateTime
]

{ #category : #'private - accessing' }
TimestampingSystemUserStoryTest >> timestampingSystem [
	
	^ rootSystem >> #TimestampingSystemInterface
]
