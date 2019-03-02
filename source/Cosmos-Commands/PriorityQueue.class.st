"
I'm a priority queue..

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

{ #category : #'instance creation' }
PriorityQueue class >> empty [
	
	^ super new 
]

{ #category : #'enqueuing - dequeiung' }
PriorityQueue >> dequeue [

	^ elements removeLast element 
]

{ #category : #'enqueuing - dequeiung' }
PriorityQueue >> enqueue: anElement with: aPriority [

	| element |

	element := PrioritizedElement holding: anElement with: aPriority.

	elements add: element 
]

{ #category : #accessing }
PriorityQueue >> enqueuedElements [

	^ elements reversed collect: #element
]

{ #category : #initialization }
PriorityQueue >> initialize [

	elements := SortedCollection sortBlock: [ :x :y | x priority < y priority ].
]

{ #category : #testing }
PriorityQueue >> isEmpty [

	^ elements isEmpty
]
