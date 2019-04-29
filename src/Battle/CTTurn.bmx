SuperStrict

Import "../Game/CTPlayer.bmx"
Import "CTTurnSelections.bmx"
Import "CTActionable.bmx"

Interface CTTurnDelegate
    Method TurnDidSelectActor(turn:CTTurn, actorToken:CTToken)
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
        Self.selection.SelectActor()
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
    Method TurnSelectionsDidSelectActor(service:CTTurnSelections, actorToken:CTToken)
        ' FIXME: Cannot call delegate with `Self.` prefix, see: <https://github.com/bmx-ng/bcc/issues/428>
        If Self.delegate Then delegate.TurnDidSelectActor(Self, actorToken)
    End Method

    Method TurnSelectionsDidSelectTarget(service:CTTurnSelections, targetToken:CTToken)
        ' FIXME: Cannot call delegate with `Self.` prefix, see: <https://github.com/bmx-ng/bcc/issues/428>
        If Self.delegate Then delegate.TurnDidSelectTargetForActionOfActor(Self, targetToken, Self.currentAction, Self.currentActor)
    End Method
    '#End Region


    '#Region CTDrivesActions
    Public
    Method SelectEffectTargetForAction(action:CTTargetableActionable)
        ' Cache pending action
        Self.currentAction = action
        Self.selection.SelectTarget()
    End Method

    Method ApplyEffectToTarget(effect:CTTargetedEffect, target:CTEffectTarget)
        effect.ApplyToTarget(target)
    End Method
    '#End Region
End Type
