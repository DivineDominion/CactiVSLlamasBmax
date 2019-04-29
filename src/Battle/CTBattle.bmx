SuperStrict

Import "../Battlefield/CTBattlefieldWindowController.bmx"
Import "CTActionMenuWindowController.bmx"
Import "CTActionable.bmx"
Import "CTTargetedToken.bmx"

Type CTBattle Implements CTDrivesActions, CTTokenSelectionControllerDelegate, CTActionMenuViewControllerDelegate
    Private
    Field battlefieldWindowController:CTBattlefieldWindowController = Null

    Public
    Method New(battlefieldWinFrameRect:CTRect, battlefield:CTBattlefield)
        Self.battlefieldWindowController = New CTBattlefieldWindowController(battlefieldWinFrameRect, battlefield)
    End Method

    Method ShowBattlefield()
        Self.battlefieldWindowController.Show()
        Self.SelectActor()
    End Method

    Method CloseBattlefield()
        CloseActionsMenu()
        Self.battlefieldWindowController.Close()
    End Method


    '#Region CTTokenSelectionControllerDelegate
    Public
    Method TokenSelectionControllerDidSelectToken(controller:CTTokenSelectionController, token:CTToken)
        If controller = Self.actorSelectionSession
            ShowActionsForToken(token)
        Else If controller = Self.targetSelectionSession
            Assert targetSelectionAction Else "Expected #targetSelectionAction to exist"
            Local target:CTTargetedToken = New CTTargetedToken(token)
            targetSelectionAction.ExecuteInDriverWithTarget(Self, target)
        End If
    End Method
    '#End Region


    '#Region Selecting Tokens
    Private
    Field currentMenuHandler:CTActionMenuWindowController = Null

    Public
    Method ShowActionsForToken(token:CTToken)
        Assert Not Self.currentMenuHandler Else "Expected currentMenuHandler to be Null"

        Local character:CTCharacter = token.GetCharacter()

        Local actions:CTActionable[] = CTActionFactory.FighterActions()
        Local window:CTWindow = battlefieldWindowController.Window()
        Local rect:CTRect = window.FrameRect()
        Local menuFrameRect:CTRect = CTWindow.FrameRectFittingLinesAndTitle(..
            rect.GetX(), rect.GetMaxY() + 2, ..
            rect.GetWidth(), actions.length, ..
            "(Char Name)")

        Self.currentMenuHandler = New CTActionMenuWindowController(menuFrameRect, character.GetName(), actions)
        Self.currentMenuHandler.ShowMenu(Self)
    End Method

    Method CloseActionsMenu()
        If Not Self.currentMenuHandler Then Return
        Self.currentMenuHandler.CloseMenu()
        Self.currentMenuHandler = Null
    End Method
    '#End Region


    '#Region CTActionMenuViewControllerDelegate
    Method ActionMenuViewControllerDidSelectAction(controller:CTActionMenuViewController, action:CTActionable)
        action.ExecuteInDriver(Self)
        CloseActionsMenu()
    End Method

    Method ActionMenuViewControllerDidCancel(controller:CTActionMenuViewController)
        CloseActionsMenu()
    End Method
    '#End Redion


    '#Region CTDrivesActions
    Private
    Field actorSelectionSession:Object = Null
    Field targetSelectionSession:Object = Null
    Field targetSelectionAction:CTTargetableActionable = Null

    Public
    Method SelectEffectTargetForAction(action:CTTargetableActionable)
        Self.targetSelectionAction = action
        SelectTarget()
    End MEthod

    Method ApplyEffectToTarget(effect:CTTargetedEffect, target:CTEffectTarget)
        effect.ApplyToTarget(target)
    End Method

    Private
    Method SelectActor()
        Self.actorSelectionSession = Self.battlefieldWindowController.StartSelectingTokenWithDelegate(Self)
    End Method

    Method SelectTarget()
        Self.targetSelectionSession = Self.battlefieldWindowController.StartSelectingTokenWithDelegate(Self)
    End Method
    '#End Region
End Type
