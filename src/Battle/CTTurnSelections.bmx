SuperStrict

Import "../Battlefield/CTBattlefieldWindowController.bmx"
Import "../Battlefield/CTToken.bmx"
Import "../Battlefield/CTTokenSelectionController.bmx"

Interface CTTurnSelectionsDelegate
    Method TurnSelectionsDidChangeHighlightedActor(service:CTTurnSelections, actorToken:CTToken)
    Method TurnSelectionsDidSelectActor(service:CTTurnSelections, actorToken:CTToken)

    Method TurnSelectionsDidChangeHighlightedTarget(service:CTTurnSelections, targetToken:CTToken)
    Method TurnSelectionsDidSelectTarget(service:CTTurnSelections, targetToken:CTToken)
End Interface

Type CTTurnSelections Implements CTTokenSelectionControllerDelegate
    Private
    Field battlefieldWindowController:CTBattlefieldWindowController = Null

    Public
    Field delegate:CTTurnSelectionsDelegate = Null

    Method New(battlefieldWindowController:CTBattlefieldWindowController)
        Assert battlefieldWindowController Else "CTTurn requires battlefieldWindowController"
        Self.battlefieldWindowController = battlefieldWindowController
    End Method

    Method TearDown()
        RemoveSelectionSessions()
        Self.delegate = Null
    End Method

    Private
    Method RemoveSelectionSessions()
        If Self.actorSelectionSession Then Self.battlefieldWindowController.StopSelection(actorSelectionSession)
        If Self.targetSelectionSession Then Self.battlefieldWindowController.StopSelection(targetSelectionSession)
    End Method

    Method FireInitialSelection(controller:CTTokenSelectionController)
        Self.TokenSelectionControllerDidChangeHighlightedToken(controller, controller.SelectedTokenInBattlefield())
    End Method


    '#Region Actor Selection
    Private
    Field actorSelectionSession:CTTokenSelectionController = Null

    Public
    Method SelectActor(initialTokenPosition:CTTokenPosition)
        Assert Not actorSelectionSession Else "#SelectActor cannot be called twice"
        Self.actorSelectionSession = CTTokenSelectionController(..
            Self.battlefieldWindowController.StartSelectingTokenWithDelegateAndInitialPosition(Self, initialTokenPosition))
        Self.FireInitialSelection(Self.actorSelectionSession)
    End Method
    '#End Region


    '#Region Target Selection
    Private
    Field targetSelectionSession:CTTokenSelectionController = Null

    Public
    Method SelectTarget(initialTokenPosition:CTTokenPosition)
        Assert Not targetSelectionSession Else "#SelectActor cannot be called twice"
        ' TODO select token based on Self.player + action target (opponent or own party)
        Self.targetSelectionSession = CTTokenSelectionController(..
            Self.battlefieldWindowController.StartSelectingTokenWithDelegateAndInitialPosition(Self, initialTokenPosition))
        Self.FireInitialSelection(Self.targetSelectionSession)
    End Method
    '#End Region


    '#Region CTTokenSelectionControllerDelegate
    Public
    Method TokenSelectionControllerDidSelectToken(controller:CTTokenSelectionController, token:CTToken)
        If Not Self.delegate Then Return
        ' FIXME: Cannot call delegate with `Self.` prefix, see: <https://github.com/bmx-ng/bcc/issues/428>
        If controller = Self.actorSelectionSession
            delegate.TurnSelectionsDidSelectActor(Self, token)
        Else If controller = Self.targetSelectionSession
            delegate.TurnSelectionsDidSelectTarget(Self, token)
        End If
    End Method

    Method TokenSelectionControllerDidChangeHighlightedToken(controller:CTTokenSelectionController, token:CTToken)
        If Not Self.delegate Then Return
        ' FIXME: Cannot call delegate with `Self.` prefix, see: <https://github.com/bmx-ng/bcc/issues/428>
        If controller = Self.actorSelectionSession
            delegate.TurnSelectionsDidChangeHighlightedActor(Self, token)
        Else If controller = Self.targetSelectionSession
            delegate.TurnSelectionsDidChangeHighlightedTarget(Self, token)
        End If
    End Method

    Method TokenSelectionControllerFilterDeadCharacters:Int(controller:CTTokenSelectionController)
        ' Dead tokens are useless at the moment, no revival, sry
        Return True
    End Method
    '#End Region
End Type
