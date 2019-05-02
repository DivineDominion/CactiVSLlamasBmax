SuperStrict

Import "../Battlefield/CTBattlefieldWindowController.bmx"
Import "CTTurn.bmx"
Import "CTSelectAction.bmx"
Import "CTTargetedToken.bmx"
Import "CTActionable.bmx"
Import "../Game/CTPlayer.bmx"
Import "CTBattleEffectDisplay.bmx"
Import "../Event.bmx"

Type CTBattleDirector Implements CTTurnDelegate
    Private
    Field battlefield:CTBattlefield
    Field battlefieldWindowController:CTBattlefieldWindowController

    Public
    Method New(battlefieldWinFrameRect:CTRect, battlefield:CTBattlefield)
        Assert battlefield Else "CTBattleDirector requires battlefield"
        Assert battlefieldWinFrameRect Else "CTBattleDirector requires battlefieldWinFrameRect"
        Self.battlefield = battlefield
        Self.battlefieldWindowController = New CTBattlefieldWindowController(battlefieldWinFrameRect, battlefield)
    End Method


    '#Region Battle lifecycle
    Private
    Field battleEffectDisplay:CTBattleEffectDisplay = Null

    Public
    Method ShowBattlefield()
        Self.battlefieldWindowController.Show()

        ' Hook service to display battle effects
        Self.battleEffectDisplay = New CTBattleEffectDisplay(Self.battlefieldWindowController.battlefield, Self.battlefieldWindowController.BattlefieldView())
        Self.battlefield.SetCharacterAnimator(Self.battleEffectDisplay)

        Self.NextTurn()
    End Method

    Method CloseBattlefield()
        If Self.turn Then turn.EndTurn()
        Self.battlefieldWindowController.Close()

        ' Remove service to display battle effects
        Self.battlefield.SetCharacterAnimator(Null)
        Self.battleEffectDisplay = Null
    End Method

    Private
    Method NextTurn()
        If Self.turn Then turn.EndTurn()

        Self.turn = New CTTurn(battlefieldWindowController)
        Self.turn.StartWithDelegate(Self)
    End Method
    '#End Region


    '#Region CTTurnDelegate
    Private
    Field turn:CTTurn

    Public
    Method TurnDidSelectActor(turn:CTTurn, actorToken:CTToken)
        ShowActionsForToken(actorToken)
    End Method

    Method TurnDidSelectTargetForActionOfActor(turn:CTTurn, targetToken:CTToken, action:CTTargetableActionable, actorToken:CTToken)
        ExercuteActionWithTargetToken(action, targetToken)
    End Method

    Private
    Method ShowActionsForToken(token:CTToken)
        CTSelectAction.ShowActions(battlefieldWindowController, token, Self.turn)
    End Method

    Method ExercuteActionWithTargetToken(action:CTTargetableActionable, targetToken:CTToken)
        Local target:CTTargetedToken = New CTTargetedToken(targetToken)
        action.ExecuteInDriverWithTarget(Self.turn, target)
        Self.NextTurn()
    End Method
    '#End Region
End Type
