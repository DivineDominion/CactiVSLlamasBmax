SuperStrict

Import "CTBattlefieldWindowController.bmx"
Import "CTSelectToken.bmx"
Import "CTToken.bmx"

' Use temporary tokens:
Import "CTCactusToken.bmx"
Import "../Army/CTCactus.bmx"

Type CTBattle Implements CTBattlefieldWindowControllerDelegate
    Private
    Field battlefieldWindowController:CTBattlefieldWindowController = Null
    Field currentTokenSelector:CTSelectToken = Null

    Public
    Method New(frameRect:CTRect, cacti:CTCactus[])
        Local cactusTokens:CTCactusToken[] = MapCactusToCactusToken(cacti)
        Assert cactusTokens.length = 3 Else "Requires 3 cacti during demo"
        Local battlefield:CTBattlefield = New CTBattlefield
        battlefield.PutTokenAtColumnRow(cactusTokens[0], 0, 0)
        battlefield.PutTokenAtColumnRow(cactusTokens[1], 1, 0)
        battlefield.PutTokenAtColumnRow(cactusTokens[2], 1, 1)

        Self.battlefieldWindowController = New CTBattlefieldWindowController(frameRect, battlefield)
    End Method

    Method ShowBattlefield()
        Self.battlefieldWindowController.Show(Self)
    End Method

    Method CloseBattlefield()
        If Self.currentTokenSelector Then Self.currentTokenSelector.delegate = Null
        Self.battlefieldWindowController.Close()
    End Method


    '#Region CTBattlefieldWindowControllerDelegate
    Public
    Method BattlefieldWindowControllerDidSelectToken(windowController:CTBattlefieldWindowController, token:CTToken)
        If Self.battlefieldWindowController <> windowController Then Return
        ' TODO: change action per character
        ShowTokenSelection()
    End Method

    Private
    Method ShowTokenSelection()
        Local window:CTWindow = battlefieldWindowController.Window()
        Self.currentTokenSelector = CTSelectToken.CreateWithActionMenuRelativeToRect(window.FrameRect())
        Self.currentTokenSelector.ShowMenu()
    End Method
    '#End Region


    '#Region CTSelectTokenDelegate
    Public
    Method SelectTokenDidSelectAction(selectToken:CTSelectToken, action:String)
        If Self.currentTokenSelector <> selectToken Then Return
        ' Free up connection to subcomponent to break reference cycle
        Self.currentTokenSelector.delegate = Null
        Self.currentTokenSelector = Null
    End Method
    '#End Region
End Type

Private
Function MapCactusToCactusToken:CTCactusToken[](cacti:CTCactus[])
    Local result:CTCactusToken[cacti.length]
    For Local i:Int = 0 Until cacti.length
        result[i] = New CTCactusToken(cacti[i])
    Next
    Return result
End Function
