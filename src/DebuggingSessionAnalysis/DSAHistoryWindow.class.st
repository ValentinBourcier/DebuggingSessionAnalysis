Class {
	#name : #DSAHistoryWindow,
	#superclass : #Object,
	#instVars : [
		'windowId',
		'jumps',
		'previousWindowHistory',
		'nextHistoryWindows',
		'annotation'
	],
	#category : #DebuggingSessionAnalysis
}

{ #category : #'instance creation' }
DSAHistoryWindow class >> fromAssociations: associations [
	| result t |
	result := OrderedCollection new.
	associations do: [ :a |
		t := self new.
		t windowId: a key.
		t jumps: a value.
		result add: t ].
	^ result
]

{ #category : #adding }
DSAHistoryWindow >> addNextHistoryWindow: aDSAHistoryWindow [
	self assert: [ aDSAHistoryWindow isKindOf: self class ].
	nextHistoryWindows add: aDSAHistoryWindow
]

{ #category : #accessing }
DSAHistoryWindow >> annotation [

	^ annotation ifNil:[annotation := DSWindowAnnotation new]
]

{ #category : #accessing }
DSAHistoryWindow >> annotation: anObject [

	annotation := anObject
]

{ #category : #testing }
DSAHistoryWindow >> color [
	self isBrowser ifTrue: [ ^ Color green ].
	self isImplementorOrSender ifTrue: [ ^ Color lightGreen ].
	self isInspector ifTrue: [ ^ Color blue ].
	self isDebugger ifTrue: [ ^ Color pink ].
	^ Color gray.
]

{ #category : #'as yet unclassified' }
DSAHistoryWindow >> initialize [

	super initialize.
	nextHistoryWindows := OrderedCollection new
]

{ #category : #'public - inspector' }
DSAHistoryWindow >> inspectionAnnotation [

	<inspectorPresentationOrder: 50 title: 'Annotation'>
	^ DSWindowElementAnnotationPresenter on: self
]

{ #category : #testing }
DSAHistoryWindow >> isBrowser [

	^ self jumps first printString beginsWith: 'Browser'
]

{ #category : #testing }
DSAHistoryWindow >> isDebugger [

	^ self jumps first printString beginsWith: 'Debugger'
]

{ #category : #testing }
DSAHistoryWindow >> isImplementorOrSender [
	| str |
	str := self jumps first printString.
	^ (str beginsWith: 'Implementor') or: [ str beginsWith: 'Senders' ]
]

{ #category : #testing }
DSAHistoryWindow >> isInspector [

	^ self jumps first printString beginsWith: 'Inspector'
]

{ #category : #accessing }
DSAHistoryWindow >> jumps [

	^ jumps
]

{ #category : #accessing }
DSAHistoryWindow >> jumps: anObject [

	jumps := anObject
]

{ #category : #adding }
DSAHistoryWindow >> nextHistoryWindows [

	^ nextHistoryWindows
]

{ #category : #'as yet unclassified' }
DSAHistoryWindow >> numberOfJumps [

	^ self jumps size
]

{ #category : #accessing }
DSAHistoryWindow >> previousWindowHistory [

	^ previousWindowHistory
]

{ #category : #accessing }
DSAHistoryWindow >> previousWindowHistory: anObject [

	previousWindowHistory := anObject
]

{ #category : #printing }
DSAHistoryWindow >> printOn: str [
	super printOn: str.
	str nextPut: $(.
	self isDebugger ifTrue: [ str nextPutAll: 'Debugger' ].
	self isInspector ifTrue: [ str nextPutAll: 'Inspector' ].
	self isBrowser ifTrue: [ str nextPutAll: 'Browser' ].
	self isImplementorOrSender ifTrue: [ str nextPutAll: 'Implementor/Sender' ].
	str nextPut: $)
]

{ #category : #accessing }
DSAHistoryWindow >> windowId [

	^ windowId
]

{ #category : #accessing }
DSAHistoryWindow >> windowId: anObject [

	windowId := anObject
]
