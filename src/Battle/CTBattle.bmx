SuperStrict

Import "../Battlefield/CTBattlefieldWindowController.bmx"
Import "CTActionMenuWindowController.bmx"

Type CTBattle Implements CTTokenSelectionControllerDelegate, CTActionMenuControllerDelegate
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

    Private
    Field actorSelectionSession:Object = Null
    Field targetSelectionSession:Object = Null

    Method SelectActor()
        ' TODO: cache selection session
        Self.actorSelectionSession = Self.battlefieldWindowController.StartSelectingTokenWithDelegate(Self)
    End Method


    '#Region CTTokenSelectionControllerDelegate
    Public
    Method TokenSelectionControllerDidSelectToken(controller:CTTokenSelectionController, token:CTToken)
        ShowActionsForToken(token)
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


    '#Region CTActionMenuControllerDelegate
    Method ActionMenuControllerDidSelectAction(controller:CTActionMenuController, action:CTActionable)
        DebugLog("ACTION: " + action.GetLabel())
        CloseActionsMenu()
    End Method

    Method ActionMenuControllerDidCancel(controller:CTActionMenuController)
        CloseActionsMenu()
    End Method
    '#End Redion
End Type
