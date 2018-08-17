"
I'm a priority queueu.

I know how to queue and dequeue objects. Objects dequeue according to its priority. 
"
Class {
	#name : #PriorityQueue,
	#superclass : #Object,
	#instVars : [
		'elements'
	],
	#category : #'Cosmos-Commands'
}

{ #category : #'Instance Creation' }
PriorityQueue class >> empty [
	
	^ super new initialize 
]

{ #category : #'Enqueuing - Dequeiung' }
PriorityQueue >> dequeue [

	^ elements removeLast element 
]

{ #category : #'Enqueuing - Dequeiung' }
PriorityQueue >> enqueue: anElement with: aPriority [

	| element |

	element := PrioritizedElement holding: anElement with: aPriority.

	elements add: element 
]

{ #category : #Initialization }
PriorityQueue >> initialize [

	elements := SortedCollection sortBlock: [ :x :y | x priority < y priority ].
]

{ #category : #Testing }
PriorityQueue >> isEmpty [

	^ elements isEmpty
]
