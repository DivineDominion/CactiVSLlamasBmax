SuperStrict

Import "../Game/CTPlayer.bmx"
Import "../View/CTWindowManager.bmx"
Import "CTPartyPickerView.bmx"

Type CTPickParty
    Private
    Field player:CTPlayer
    Field frameRect:CTRect
    Field partyPickerView:CTPartyPickerView

    Method New(); End Method

    Public
    Function Create:CTPickParty(frameRect:CTRect, player:CTPlayer)
        Assert frameRect Else "CTPickParty requires frameRect"

        Local service:CTPickParty = New CTPickParty
        service.frameRect = frameRect
        service.player = player
        service.partyPickerView = New CTPartyPickerView(player)
        Return service
    End Function

    '#Region Window lifecycle management
    Private
    Field currentWindow:CTWindow = Null

    Public
    Method ShowPartyPicker()
        Assert Not Self.currentWindow Else "#ShowPartyPicker called before closing the window"

        Self.currentWindow = CTWindow.Create(Self.frameRect, Self.partyPickerView, "Pick Party")
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
