SuperStrict

Import "../Event.bmx"
Import "../Battlefield/CTBattlefieldWindowController.bmx"
Import "../Game/CTPlayer.bmx"
Import "CTBattle.bmx"
Import "CTTurn.bmx"
Import "CTTargetedToken.bmx"
Import "CTActionable.bmx"
Import "CTBattleEffectDisplay.bmx"
Import "CTSelectAction.bmx"
Import "CTShowTurnStatus.bmx"

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
    '#End Region


    '#Region Taking Turns
    Private
    Field currentPlayer:CTPlayer = Null

    Protected
    Method NextTurn()
        Self.ResetShowTurnStatus()

        If Self.turn Then turn.EndTurn()

        ' TODO: take turns
        If Not Self.currentPlayer Then Self.currentPlayer = CTPlayer.cactusPlayer

        Self.turn = New CTTurn(battlefieldWindowController)
        Self.turn.StartWithDelegate(Self)
    End Method
    '#End Region


    '#Region CTTurnDelegate
    Private
    Field turn:CTTurn

    Public
    Method InitialActorTokenPositionForTurn:CTTokenPosition(turn:CTTurn)
        Return Self.FirstTokenPositionForPlayer(Self.currentPlayer)
    End Method

    Method TurnDidSelectActor(turn:CTTurn, actorToken:CTToken)
        ShowActionsForToken(actorToken)
    End Method

    Method TurnDidChangeHighlightedActor(turn:CTTurn, token:CTToken)
        If token
            Self.ShowActorStatus(token)
        Else
            Self.HideActorStatus()
        End If
    End Method

    Method TurnDidChangeHighlightedTargetForAction(turn:CTTurn, token:CTToken, action:CTActionable)
        Self.ShowActionStatus(action)
    End Method

    Method InitialTargetTokenPositionForTurnAndAction:CTTokenPosition(turn:CTTurn, action:CTTargetableActionable)
        Return Self.FirstTokenPositionForPlayer(Self.currentPlayer.Opponent())
    End Method

    Method TurnDidSelectTargetForActionOfActor(turn:CTTurn, targetToken:CTToken, action:CTTargetableActionable, actorToken:CTToken)
        ExercuteActionWithTargetToken(action, targetToken)
    End Method

    Private
    Method FirstTokenPositionForPlayer:CTTokenPosition(player:CTPlayer)
        Local token:CTToken = Self.battle.battlefield.FirstTokenInCharacterList(New TList.FromArray(player.army.characters))
        If Not token Then Return Null
        Return Self.battle.battlefield.PositionOfToken(token)
    End Method

    Method ShowActionsForToken(token:CTToken)
        CTSelectAction.ShowActions(battlefieldWindowController, token, Self.turn)
    End Method

    Method ExercuteActionWithTargetToken(action:CTTargetableActionable, targetToken:CTToken)
        Local target:CTTargetedToken = New CTTargetedToken(targetToken)
        action.ExecuteInDriverWithTarget(Self.turn, target)
        Self.NextTurn()
    End Method
    '#End Region


    '#Region Selection status
    Private
    Field turnStatus:CTShowTurnStatus = Null

    Public
    Method ShowActorStatus(token:CTToken)
        PrepareShowTurnStatus()
        Self.turnStatus.ShowActorStatus(token.GetCharacter())
    End Method

    Method HideActorStatus()
        PrepareShowTurnStatus()
        Self.turnStatus.HideActorStatus()
    End Method

    Method ShowActionStatus(action:CTActionable)
        PrepareShowTurnStatus()
        Self.turnStatus.ShowActionStatus(action)
    End Method

    Private
    Method PrepareShowTurnStatus()
        If Self.turnStatus Then Return
        Self.turnStatus = New CTShowTurnStatus.CreateBelowWindowController(battlefieldWindowController)
    End Method

    Method ResetShowTurnStatus()
        If Not Self.turnStatus Then Return
        Self.turnStatus.HideActorStatus()
        Self.turnStatus.HideActionStatus()
    End Method
    '#End Region
End Type

