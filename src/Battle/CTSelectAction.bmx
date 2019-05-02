SuperStrict

Import "../Battlefield/CTBattlefieldWindowController.bmx"
Import "../Battlefield/CTToken.bmx"
Import "CTActionMenuWindowController.bmx"
Import "CTActionable.bmx"
Import "CTActionFactory.bmx"

Rem
By the nature of CTActionMenuWindowController delegate not being weak, calling
#ShowActions will keep this object alive
until a choice was made, so you don't need to manage the instance at all.
End Rem
Type CTSelectAction Implements CTActionMenuViewControllerDelegate
    Private
    Field battlefieldWindowController:CTBattlefieldWindowController = Null

    Public
    Method New(battlefieldWindowController:CTBattlefieldWindowController)
        Assert battlefieldWindowController Else "CTSelectAction requires battlefieldWindowController"
        Self.battlefieldWindowController = battlefieldWindowController
    End Method

    Function ShowActions(battlefieldWindowController:CTBattlefieldWindowController, token:CTToken, driver:CTDrivesActions)
        Local service:CTSelectAction = New CTSelectAction(battlefieldWindowController)
        service.RunForToken(token, driver)
    End Function


    '#Region Selecting Tokens on the Battlefield during a Selection Session
    Private
    Field currentActionMenu:CTActionMenuWindowController = Null
    Field currentDriver:CTDrivesActions = Null

    Public
    Method RunForToken(token:CTToken, driver:CTDrivesActions)
        Assert token Else "#RunForToken requires token"
        Assert driver Else "#RunForToken requires driver"

        Assert Not Self.currentActionMenu Else "Expected currentActionMenu to be Null"

        Local character:CTCharacter = token.GetCharacter()

        Local actions:CTActionable[] = CTActionFactory.FighterActionsForCharacter(character)
        Local window:CTWindow = Self.battlefieldWindowController.Window()
        Local rect:CTRect = window.FrameRect()
        Local menuFrameRect:CTRect = CTWindow.FrameRectFittingLinesAndTitle(..
            rect.GetX(), rect.GetMaxY() + 2, ..
            rect.GetWidth(), actions.length, ..
            "Char.name is the title")

        Self.currentDriver = driver
        Self.currentActionMenu = New CTActionMenuWindowController(menuFrameRect, character.GetName(), actions)
        Self.currentActionMenu.ShowMenu(Self)
    End Method
    '#End Region


    '#Region CTActionMenuViewControllerDelegate
    Public
    Method ActionMenuViewControllerDidSelectAction(controller:CTActionMenuViewController, action:CTActionable)
        Assert currentDriver Else "Expected currentDriver to be set during selection"
        action.ExecuteInDriver(currentDriver)
        CloseActionsMenu()
    End Method

    Method ActionMenuViewControllerDidCancel(controller:CTActionMenuViewController)
        CloseActionsMenu()
    End Method

    Private
    Method CloseActionsMenu()
        If Not Self.currentActionMenu Then Return
        Self.currentActionMenu.CloseMenu()
        Self.currentActionMenu = Null
    End Method
    '#End Region
End Type
