SuperStrict

Import "../View/CTWindow.bmx"
Import "../View/CTWindowManager.bmx"

Import "CTBattlefield.bmx"
Import "CTBattlefieldView.bmx"
Import "CTSelectToken.bmx"

' Use temporary tokens:
Import "CTCactusToken.bmx"
Import "../Army/CTCactus.bmx"

Type CTBattle Implements CTBattlefieldViewDelegate, CTSelectTokenDelegate
    Private
    Field frameRect:CTRect

    Field battlefield:CTBattlefield
    Field battlefieldView:CTBattlefieldView

    Field currentTokenSelector:CTSelectToken = Null

    Method New(); End Method

    Public
    Method New(frameRect:CTRect, cacti:CTCactus[])
        Assert frameRect Else "CTBattle requires frameRect"
        Self.frameRect = frameRect

        Local cactusTokens:CTCactusToken[] = MapCactusToCactusToken(cacti)
        Assert cactusTokens.length = 3 Else "Requires 3 cacti during demo"
        Self.battlefield = New CTBattlefield
        Self.battlefield.PutTokenAtColumnRow(cactusTokens[0], 0, 0)
        Self.battlefield.PutTokenAtColumnRow(cactusTokens[1], 1, 0)
        Self.battlefield.PutTokenAtColumnRow(cactusTokens[2], 1, 1)
    End Method


    '#Region Window lifecycle management
    Private
    Field currentWindow:CTWindow = Null

    Public
    Method ShowBattlefield()
        Assert Not Self.currentWindow Else "#ShowBattlefield called before closing the window"

        Self.battlefieldView = New CTBattlefieldView(battlefield)
        Self.battlefieldView.delegate = Self
        Self.currentWindow = CTWindow.Create(Self.frameRect, Self.battlefieldView)
        CTWindowManager.GetInstance().AddWindowAndMakeKey(currentWindow)
    End Method

    Method CloseWindow()
        Assert Self.currentWindow Else "#CloseWindow called without active window"
        If Self.currentWindow = Null Then Return

        Self.battlefieldView.TearDown()
        Self.battlefieldView = Null

        If Self.currentTokenSelector Then Self.currentTokenSelector.delegate = Null

        CTWindowManager.GetInstance().RemoveWindow(Self.currentWindow)
        Self.currentWindow.Close()
        Self.currentWindow = Null
    End Method
    '#End Region


    '#Region CTBattlefieldViewDelegate
    Public
    Method BattleFieldViewDidSelectToken(battlefieldView:CTBattlefieldView, token:CTToken)
        If Self.battlefieldView <> battlefieldView Then Return
        ShowTokenSelection()
    End Method

    Private
    Method ShowTokenSelection()
        Self.currentTokenSelector = CTSelectToken.CreateWithActionMenuRelativeToRect(Self.currentWindow.FrameRect())
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
