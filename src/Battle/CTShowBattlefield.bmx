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
    Field currentWindow:CTWindow = Null


    Public
    Function Create:CTShowBattlefield(frameRect:CTRect)
        Local service:CTShowBattlefield = New CTShowBattlefield
        service.frameRect = frameRect

        Local battlefield:CTBattlefield = New CTBattlefield
        battlefield.AddToken(New CTCactusToken(New CTTokenPosition(0, 0)))
        battlefield.AddToken(New CTCactusToken(New CTTokenPosition(1, 0)))
        battlefield.AddToken(New CTCactusToken(New CTTokenPosition(1, 1)))
        service.battlefieldView = New CTBattlefieldView(battlefield)

        Return service
    End Function

    Method ShowBattlefield()
        Assert Not Self.currentWindow Else "#ShowMenu called before closing the window"

        Self.currentWindow = CTWindow.Create(Self.frameRect, Self.battlefieldView)
        windowManager.AddWindow(currentWindow)
    End Method

End Type
