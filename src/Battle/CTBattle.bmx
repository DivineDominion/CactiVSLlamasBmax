SuperStrict

Import "CTBattlefieldWindowController.bmx"
Import "CTShowActionMenu.bmx"

' Use temporary tokens:
Import "../Battlefield/CTCactusToken.bmx"
Import "../Army/CTCactus.bmx"

Type CTBattle Implements CTBattlefieldWindowControllerDelegate, CTShowActionMenuDelegate
    Private
    Field battlefieldWindowController:CTBattlefieldWindowController = Null

    Public
    Method New(frameRect:CTRect, battlefield:CTBattlefield)
        ' Local cactusTokens:CTCactusToken[] = MapCactusToCactusToken(cacti)
        ' Assert cactusTokens.length = 3 Else "Requires 3 cacti during demo"
        ' Local battlefield:CTBattlefield = New CTBattlefield
        ' battlefield.PutTokenAtColumnRow(cactusTokens[0], 0, 0)
        ' battlefield.PutTokenAtColumnRow(cactusTokens[1], 1, 0)
        ' battlefield.PutTokenAtColumnRow(cactusTokens[2], 1, 1)

        Self.battlefieldWindowController = New CTBattlefieldWindowController(frameRect, battlefield)
    End Method

    Method ShowBattlefield()
        Self.battlefieldWindowController.Show(Self)
        ' TODO: cache selection session
        Local session:Object = Self.battlefieldWindowController.StartSelectingToken()
    End Method

    Method CloseBattlefield()
        CloseActionsMenu()
        Self.battlefieldWindowController.Close()
    End Method


    '#Region CTBattlefieldWindowControllerDelegate
    Public
    Method BattlefieldWindowControllerDidSelectToken(windowController:CTBattlefieldWindowController, token:CTToken)
        If Self.battlefieldWindowController <> windowController Then Return
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
            rect.GetWidth(), lines.length)

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

' Private
' Function MapCactusToCactusToken:CTCactusToken[](cacti:CTCactus[])
'     Local result:CTCactusToken[cacti.length]
'     For Local i:Int = 0 Until cacti.length
'         result[i] = New CTCactusToken(cacti[i])
'     Next
'     Return result
' End Function
