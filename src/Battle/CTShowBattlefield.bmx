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
        battlefield.PutTokenAtColumnRow(New CTCactusToken, 0, 0)
        battlefield.PutTokenAtColumnRow(New CTCactusToken, 1, 0)
        battlefield.PutTokenAtColumnRow(New CTCactusToken, 1, 1)
        service.battlefieldView = New CTBattlefieldView(battlefield)

        Return service
    End Function

    Method ShowBattlefield()
        Assert Not Self.currentWindow Else "#ShowMenu called before closing the window"

        Self.currentWindow = CTWindow.Create(Self.frameRect, Self.battlefieldView)
        Self.battlefieldView.MakeFirstResponder()
        windowManager.AddWindow(currentWindow)
    End Method

End Type
