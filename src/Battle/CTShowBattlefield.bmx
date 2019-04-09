SuperStrict

Import "../View/CTWindow.bmx"
Import "../View/CTWindowManager.bmx"

Import "CTBattlefield.bmx"
Import "CTBattlefieldView.bmx"

' Use temporary tokens:
Import "CTCactusToken.bmx"

Type CTShowBattlefield
    Private
    Field frameRect:CTRect
    Field battlefieldView:CTBattlefieldView

    Method New(); End Method

    Public
    Function Create:CTShowBattlefield(frameRect:CTRect)
        Assert frameRect Else "CTShowBattlefield requires frameRect"

        Local service:CTShowBattlefield = New CTShowBattlefield
        service.frameRect = frameRect

        Local battlefield:CTBattlefield = New CTBattlefield
        battlefield.PutTokenAtColumnRow(New CTCactusToken, 0, 0)
        battlefield.PutTokenAtColumnRow(New CTCactusToken, 1, 0)
        battlefield.PutTokenAtColumnRow(New CTCactusToken, 1, 1)
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
