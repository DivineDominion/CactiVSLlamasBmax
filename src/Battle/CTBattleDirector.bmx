SuperStrict

Import "../Battlefield/CTBattlefieldWindowController.bmx"
Import "CTTurn.bmx"
Import "CTSelectAction.bmx"
Import "CTTargetedToken.bmx"
Import "CTActionable.bmx"
Import "../Game/CTPlayer.bmx"

Type CTBattleDirector Implements CTTurnDelegate
    Private
    Field battlefieldWindowController:CTBattlefieldWindowController = Null

    Public
    Method New(battlefieldWinFrameRect:CTRect, battlefield:CTBattlefield)
        Self.battlefieldWindowController = New CTBattlefieldWindowController(battlefieldWinFrameRect, battlefield)
    End Method

    Method ShowBattlefield()
        Self.battlefieldWindowController.Show()
        Self.NextTurn()
    End Method

    Method CloseBattlefield()
        If Self.turn Then turn.EndTurn()
        Self.battlefieldWindowController.Close()
    End Method

    Private
    Method NextTurn()
        If Self.turn Then turn.EndTurn()

        Self.turn = New CTTurn(battlefieldWindowController)
        Self.turn.StartWithDelegate(Self)
    End Method


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

