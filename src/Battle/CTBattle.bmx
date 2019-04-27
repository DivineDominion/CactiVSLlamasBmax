SuperStrict

Import "../Battlefield/CTBattlefieldWindowController.bmx"
Import "CTShowActionMenu.bmx"

Type CTBattle Implements CTShowActionMenuDelegate, CTTokenSelectionControllerDelegate
    Private
    Field battlefieldWindowController:CTBattlefieldWindowController = Null

    Public
    Method New(frameRect:CTRect, battlefield:CTBattlefield)
        Self.battlefieldWindowController = New CTBattlefieldWindowController(frameRect, battlefield)
    End Method

    Method ShowBattlefield()
        Self.battlefieldWindowController.Show()
        ' TODO: cache selection session
        Local session:Object = Self.battlefieldWindowController.StartSelectingTokenWithDelegate(Self)
    End Method

    Method CloseBattlefield()
        CloseActionsMenu()
        Self.battlefieldWindowController.Close()
    End Method


    '#Region CTTokenSelectionControllerDelegate
    Public
    Method TokenSelectionControllerDidSelectToken(controller:CTTokenSelectionController, token:CTToken)
        ShowActionsForToken(token)
    End Method
    '#End Region

    '#Region Selecting Tokens
    Private
    Field currentMenuHandler:CTShowActionMenu = Null

    Public
    Method ShowActionsForToken(token:CTToken)
        Assert Not Self.currentMenuHandler Else "Expected currentMenuHandler to be Null"

        Local character:CTCharacter = token.GetCharacter()
        Local lines:String[] = ["Fight", "Move", "", "Run"]

        Local window:CTWindow = battlefieldWindowController.Window()
        Local rect:CTRect = window.FrameRect()
        Local menuFrameRect:CTRect = CTWindow.FrameRectFittingLinesAndTitle(..
            rect.GetX(), rect.GetMaxY() + 2, ..
            rect.GetWidth(), lines.length, ..
            "(Char Name)")

        Self.currentMenuHandler = New CTShowActionMenu(menuFrameRect, lines, character.GetName())
        Self.currentMenuHandler.delegate = Self
        Self.currentMenuHandler.ShowMenu()
    End Method

    Method CloseActionsMenu()
        If Not Self.currentMenuHandler Then Return
        Self.currentMenuHandler.CloseMenu()
        Self.currentMenuHandler.delegate = Null
        Self.currentMenuHandler = Null
    End Method
    '#End Region

    '#Region CTShowActionMenuDelegate
    Public
    Method ShowActionMenuDidSelectAction(showActionMenu:CTShowActionMenu, action:String)
        If Self.currentMenuHandler <> showActionMenu Then Return
        DebugLog("ACTION: " + action)
        CloseActionsMenu()
    End Method

    Method ShowActionMenuDidCancel(showActionMenu:CTShowActionMenu)
        If Self.currentMenuHandler <> showActionMenu Then Return
        CloseActionsMenu()
    End Method
    '#End Region
End Type
