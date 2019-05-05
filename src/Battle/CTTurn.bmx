SuperStrict

Import "../Game/CTPlayer.bmx"
Import "../Battlefield/CTTokenPosition.bmx"
Import "CTTurnSelections.bmx"
Import "CTActionable.bmx"

Interface CTTurnDelegate
    Method InitialActorTokenPositionForTurn:CTTokenPosition(turn:CTTurn)
    Method TurnDidSelectActor(turn:CTTurn, actorToken:CTToken)

    Method TurnDidChangeHighlightedActor(turn:CTTurn, token:CTToken)
    Method TurnDidChangeHighlightedTargetForAction(turn:CTTurn, token:CTToken, action:CTActionable)

    Method InitialTargetTokenPositionForTurnAndAction:CTTokenPosition(turn:CTTurn, action:CTTargetableActionable)
    Method TurnDidSelectTargetForActionOfActor(turn:CTTurn, targetToken:CTToken, action:CTTargetableActionable, actorToken:CTToken)
End Interface

Type CTTurn Implements CTDrivesActions, CTTurnSelectionsDelegate
    Private
    Field battlefieldWindowController:CTBattlefieldWindowController = Null

    Public
    Method New(battlefieldWindowController:CTBattlefieldWindowController)
        Assert battlefieldWindowController Else "CTTurn requires battlefieldWindowController"
        Self.battlefieldWindowController = battlefieldWindowController
    End Method


    '#Region Turn Lifecycle
    Private
    Field delegate:CTTurnDelegate = Null
    Field selection:CTTurnSelections = Null
    Field currentAction:CTTargetableActionable = Null
    Field currentActor:CTToken = Null

    Public
    Method StartWithDelegate(delegate:CTTurnDelegate)
        Assert Not Self.IsStarted() Else "CTTurn#Start called twice"

        Self.delegate = delegate

        Self.selection = New CTTurnSelections(Self.battlefieldWindowController)
        Self.selection.delegate = Self
        Self.SelectActor()
    End Method

    Method EndTurn()
        Self.delegate = Null
        Self.currentAction = Null
        Self.currentActor = Null

        If Self.selection
            Self.selection.TearDown()
            Self.selection = Null
        End If
    End Method

    Private
    Method IsStarted:Int()
        Return selection <> Null
    End Method
    '#End Region


    '#Region CTTurnSelectionsDelegate
    Public
    Method TurnSelectionsDidChangeHighlightedActor(service:CTTurnSelections, actorToken:CTToken)
        ' FIXME: Cannot call delegate with `Self.` prefix, see: <https://github.com/bmx-ng/bcc/issues/428>
        If Self.delegate Then delegate.TurnDidChangeHighlightedActor(Self, actorToken)
    End Method

    Method TurnSelectionsDidSelectActor(service:CTTurnSelections, actorToken:CTToken)
        ' FIXME: Cannot call delegate with `Self.` prefix, see: <https://github.com/bmx-ng/bcc/issues/428>
        If Self.delegate Then delegate.TurnDidSelectActor(Self, actorToken)
    End Method

    Method TurnSelectionsDidChangeHighlightedTarget(service:CTTurnSelections, targetToken:CTToken)
        If Not Self.currentAction Then Return
        Local action:CTActionable = CTActionable(Self.currentAction)
        Assert action Else "Expected CTTargetableActionable to be convertible to CTActionble (cannot inherit interfaces)"
        ' FIXME: Cannot call delegate with `Self.` prefix, see: <https://github.com/bmx-ng/bcc/issues/428>
        If Self.delegate Then delegate.TurnDidChangeHighlightedTargetForAction(Self, targetToken, action)
    End Method

    Method TurnSelectionsDidSelectTarget(service:CTTurnSelections, targetToken:CTToken)
        ' FIXME: Cannot call delegate with `Self.` prefix, see: <https://github.com/bmx-ng/bcc/issues/428>
        If Self.delegate Then delegate.TurnDidSelectTargetForActionOfActor(Self, targetToken, Self.currentAction, Self.currentActor)
    End Method
    '#End Region


    '#Region CTDrivesActions
    Public
    Method SelectActor()
        Local initialActorPosition:CTTokenPosition = Self.delegate.InitialActorTokenPositionForTurn(Self)
        Self.selection.SelectActor(initialActorPosition)
    End Method

    Method SelectEffectTargetForAction(action:CTTargetableActionable)
        Local initialTargetPosition:CTTokenPosition = Self.delegate.InitialTargetTokenPositionForTurnAndAction(Self, action)
        ' Cache pending action
        Self.currentAction = action
        Self.selection.SelectTarget(initialTargetPosition)
    End Method

    Method ApplyEffectToTarget(effect:CTTargetedEffect, target:CTEffectTarget)
        effect.ApplyToTarget(target)
    End Method
    '#End Region
End Type
