SuperStrict

Import "../Event.bmx"
Import "../Battlefield/CTBattlefieldWindowController.bmx"
Import "../Game/CTPlayer.bmx"
Import "CTTurn.bmx"
Import "CTSelectAction.bmx"
Import "CTTargetedToken.bmx"
Import "CTActionable.bmx"
Import "CTBattleEffectDisplay.bmx"
Import "CTBattle.bmx"

Type CTBattleDirector Implements CTTurnDelegate
    Private
    Field battle:CTBattle
    Field battlefieldWindowController:CTBattlefieldWindowController

    Public
    Method New(battlefieldWinFrameRect:CTRect, battle:CTBattle)
        Assert battle Else "CTBattleDirector requires battle"
        Assert battlefieldWinFrameRect Else "CTBattleDirector requires battlefieldWinFrameRect"
        Self.battle = battle
        Self.battlefieldWindowController = New CTBattlefieldWindowController(battlefieldWinFrameRect, Self.battle.battlefield)
    End Method


    '#Region Battle lifecycle
    Private
    Field battleEffectDisplay:CTBattleEffectDisplay = Null

    Public
    Method ShowBattlefield()
        Self.battlefieldWindowController.Show()

        ' Hook service to display battle effects
        Self.battleEffectDisplay = New CTBattleEffectDisplay(Self.battle.battlefield, Self.battlefieldWindowController.BattlefieldView())

        Self.NextTurn()
    End Method

    Method CharacterAnimator:CTCharacterAnimator()
        Return Self.battleEffectDisplay
    End Method

    Method CloseBattlefield()
        If Self.turn Then turn.EndTurn()
        Self.battlefieldWindowController.Close()

        ' Remove service to display battle effects
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

