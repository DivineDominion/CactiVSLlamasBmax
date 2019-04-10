SuperStrict

Import "../View/CTWindow.bmx"
Import "../View/CTWindowManager.bmx"

Import "CTBattlefield.bmx"
Import "CTBattlefieldView.bmx"

' Use temporary tokens:
Import "CTCactusToken.bmx"
Import "../Army/CTCactus.bmx"

Type CTShowBattlefield
    Private
    Field frameRect:CTRect
    Field battlefieldView:CTBattlefieldView

    Method New(); End Method

    Public
    Function Create:CTShowBattlefield(frameRect:CTRect, cacti:CTCactus[])
        Assert frameRect Else "CTShowBattlefield requires frameRect"

        Local service:CTShowBattlefield = New CTShowBattlefield
        service.frameRect = frameRect

        Local battlefield:CTBattlefield = New CTBattlefield
        Local cactusTokens:CTCactusToken[] = MapCactusToCactusToken(cacti)
        Assert cactusTokens.length = 3 Else "Requires 3 cacti during demo"
        battlefield.PutTokenAtColumnRow(cactusTokens[0], 0, 0)
        battlefield.PutTokenAtColumnRow(cactusTokens[1], 1, 0)
        battlefield.PutTokenAtColumnRow(cactusTokens[2], 1, 1)
        service.battlefieldView = New CTBattlefieldView(battlefield)

        Return service
    End Function

    '#Region Window lifecycle management
    Private
    Field currentWindow:CTWindow = Null

    Public
    Method ShowBattlefield()
        Assert Not Self.currentWindow Else "#ShowBattlefield called before closing the window"

        Self.currentWindow = CTWindow.Create(Self.frameRect, Self.battlefieldView)
        CTWindowManager.GetInstance().AddWindowAndMakeKey(currentWindow)
    End Method

    Method CloseWindow()
        Assert Self.currentWindow Else "#CloseWindow called without active window"
        If Self.currentWindow = Null Then Return

        Self.currentWindow.Close()
        CTWindowManager.GetInstance().RemoveWindow(Self.currentWindow)
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
