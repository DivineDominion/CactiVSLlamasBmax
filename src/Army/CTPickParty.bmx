SuperStrict

Import "../Game/CTPlayer.bmx"
Import "CTParty.bmx"
Import "../View/CTWindowManager.bmx"
Import "CTPartyPickerView.bmx"

Interface CTPickPartyDelegate
    Method PickPartyDidPickParty(pickParty:CTPickParty, party:CTParty)
End Interface

Type CTPickParty Implements CTPartyPickerViewDelegate
    Private
    Field player:CTPlayer
    Field frameRect:CTRect

    Method New(); End Method

    Public
    Function Create:CTPickParty(frameRect:CTRect, player:CTPlayer)
        Assert frameRect Else "CTPickParty requires frameRect"
        Assert player Else "CTPickParty requires player"

        Local service:CTPickParty = New CTPickParty
        service.frameRect = frameRect
        service.player = player
        Return service
    End Function


    '#Region Window lifecycle management
    Private
    Field currentWindow:CTWindow = Null
    Field partyPickerView:CTPartyPickerView = Null
    Field delegate:CTPickPartyDelegate = Null

    Public
    Method ShowPartyPicker(delegate:CTPickPartyDelegate)
        Assert delegate Else "ShowPartyPicker requires delegate"
        Assert Not Self.currentWindow Else "#ShowPartyPicker called before closing the window"

        Self.delegate = delegate
        Self.partyPickerView = New CTPartyPickerView(Self.player)
        Self.partyPickerView.delegate = Self
        Self.currentWindow = CTWindow.Create(Self.frameRect, Self.partyPickerView, "Pick Party")
        CTWindowManager.GetInstance().AddWindowAndMakeKey(currentWindow)
    End Method

    Method CloseWindow()
        Assert Self.currentWindow Else "#CloseWindow called without active window"
        If Self.currentWindow = Null Then Return

        Self.partyPickerView.TearDown()
        Self.partyPickerView = Null

        CTWindowManager.GetInstance().RemoveWindow(Self.currentWindow)
        Self.currentWindow.Close()
        Self.currentWindow = Null
        Self.delegate = Null
    End Method
    '#End Region


    '#Region CTPartyPickerViewDelegate
    Method PartyPickerViewDidSelectParty(partyPickerView:CTPartyPickerView, selectedParty:CTParty)
        ' FIXME: Cannot call delegate with `Self.` prefix, see: <https://github.com/bmx-ng/bcc/issues/428>
        If Self.delegate Then delegate.PickPartyDidPickParty(Self, selectedParty)
    End Method
    '#End Region
End Type
