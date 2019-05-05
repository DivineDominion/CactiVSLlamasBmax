SuperStrict

Import "../Battlefield/CTBattlefieldWindowController.bmx"
Import "../Battlefield/CTToken.bmx"

Interface CTTurnSelectionsDelegate
    Method TurnSelectionsDidSelectActor(service:CTTurnSelections, actorToken:CTToken)
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


    '#Region Actor Selection
    Private
    Field actorSelectionSession:Object = Null

    Public
    Method SelectActor()
        Assert Not actorSelectionSession Else "#SelectActor cannot be called twice"
        ' TODO select token based on Self.player
        Self.actorSelectionSession = Self.battlefieldWindowController.StartSelectingTokenWithDelegate(Self)
    End Method
    '#End Region


    '#Region Target Selection
    Private
    Field targetSelectionSession:Object = Null

    Public
    Method SelectTarget()
        Assert Not targetSelectionSession Else "#SelectActor cannot be called twice"
        ' TODO select token based on Self.player + action target (opponent or own party)
        Self.targetSelectionSession = Self.battlefieldWindowController.StartSelectingTokenWithDelegate(Self)
    End Method
    '#End Region


    '#Region CTTokenSelectionControllerDelegate
    Public
    Method TokenSelectionControllerDidSelectToken(controller:CTTokenSelectionController, token:CTToken)
        If Not Self.delegate Then Return
        If controller = Self.actorSelectionSession
            delegate.TurnSelectionsDidSelectActor(Self, token)
        Else If controller = Self.targetSelectionSession
            delegate.TurnSelectionsDidSelectTarget(Self, token)
        End If
    End Method

    Method TokenSelectionControllerFilterDeadCharacters:Int(controller:CTTokenSelectionController)
        ' Dead tokens are useless at the moment, no revival, sry
        Return True
    End Method
    '#End Region
End Type
