Extension { #name : #DSWindowActivityRecord }

{ #category : #'*DebuggingSessionAnalysis' }
DSWindowActivityRecord >> debuggingActions [
	"Return all step actions and browse actions"
	^ self events select: [ :e | 
		({ DSStepActionRecord . 
		  DSBrowseContextRecord .		
		  DSSelectInspectorPageRecord .
		  DSBrowseContextRecord .
		  DSPlaygroundReadRecord
		} includes: e class) or:[(DSStepRecord allSubclasses includes:  e class) or: [DSBreakpointRecord allSubclasses includes: e class]]] 
]

{ #category : #'*DebuggingSessionAnalysis' }
DSWindowActivityRecord >> hasDebuggingOperations [
	
	^ self events anySatisfy: [ :e | (e isKindOf: DSStepRecord) or: [ e isKindOf: DSBreakpointRecord  ] ]
]

{ #category : #'*DebuggingSessionAnalysis' }
DSWindowActivityRecord >> inspectionDebuggingEvents [
	<inspectorPresentationOrder: 50 title: 'Actions'>
	^ SpRoassal3InspectorPresenter new
		canvas: self visualizeDebuggingActions;
		yourself

]

{ #category : #'*DebuggingSessionAnalysis' }
DSWindowActivityRecord >> visualizeDebuggingActions [

	| c d |
	c := RSCanvas new.
	self debuggingActions do: [ :act |
		| s s2 |
		"DEBUG ACTION"
		((act isKindOf: DSStepRecord) or: [act isKindOf: DSBreakpointRecord]) ifTrue: [
			"d := Dictionary newFromPairs: { 'Over'. '>'. 'Into'. 'V' . 'Through' . '>>' . 'Restart' . 'R' . 'Proceed' . 'P' }." 
			s := RSLabel new
				     text: act eventSymbol;
				     color: Color red.
			s2 := RSLabel new text: act printContextAndNode. ].
	
		"INSPECTION ACTION"	
		((act isKindOf: DSStepRecord) or: [act isKindOf: DSBreakpointRecord])ifFalse: [
			s := RSLabel new
				     text: 'In';
				     color: Color green.

			s2 := RSLabel new text: act eventName
		].
	
		s ifNotNil: [
		s @ RSPopup.
		c
			add: (s model: act);
			add: s2 ].
	].
	RSGridLayout new
		lineItemsCount: 2;
		on: c shapes.
	(2 to: c shapes size by: 2) do: [ :i |
		(c shapes at: i) translateBy: 40 @ 0 ].
	^ c @ RSCanvasController
]

{ #category : #'*DebuggingSessionAnalysis' }
DSWindowActivityRecord >> visualizeSummarizedDebuggingActions [

	| c d |
	c := RSCanvas new.
	self debuggingActions do: [ :act |
		| s |
		"DEBUG ACTION"
		act class == DSStepActionRecord ifTrue: [
			d := Dictionary newFromPairs: { 'Over'. '>'. 'Into'. 'V' . 'Through' . '>>' . 'Restart' . 'R' . 'Proceed' . 'P' }.
			s := RSLabel new
				     text: (d at: act eventName);
				     color: Color red ].
	
		"INSPECTION ACTION"	
		act class ~~ DSStepActionRecord ifTrue: [
			s := RSLabel new
				     text: 'In';
				     color: Color green.
		].
	
		s ifNotNil: [
			s @ RSPopup.
			c
				add: (s model: act) ].
	].
	RSGridLayout new
		on: c shapes.
	^ c @ RSCanvasController
]

{ #category : #'*DebuggingSessionAnalysis' }
DSWindowActivityRecord >> visualizeSummarizedDebuggingActionsOnGroup: g [
	"g is a RSGroup"
	self debuggingActions do: [ :act |
		| s  |
		"DEBUG ACTION"
		((act isKindOf: DSStepRecord) or: [act isKindOf: DSBreakpointRecord])  ifTrue: [
			"d := Dictionary newFromPairs: { 'Over'. '>'. 'Into'. 'V' . 'Through' . '>>' . 'Restart' . 'R' . 'Proceed' . 'P' }."
			s := RSLabel new
				     text: act eventSymbol;
				     color: Color red ].
	
		"INSPECTION ACTION"	
		((act isKindOf: DSStepRecord) or: [act isKindOf: DSBreakpointRecord])  ifFalse: [
			s := RSLabel new
				     text: 'In';
				     color: Color green.
		].
	
		s ifNotNil: [
			s @ RSPopup.
			g
				add: (s model: act) ].
	].
	RSHorizontalLineLayout new on: g.
	^ g
]
