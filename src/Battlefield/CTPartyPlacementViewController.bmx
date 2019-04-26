SuperStrict

Import "../View/CTController.bmx"
Import "CTBattlefieldView.bmx"
Import "../Army/CTParty.bmx"

Type CTPartyPlacementViewController Extends CTController
    Private
    Field battlefieldView:CTBattlefieldView

    Public
    Method New(party:CTParty)
        Self.battlefieldView = New CTBattlefieldView()
    End Method

    '#Region CTController
    Public
    Method View:CTView()
        Return battlefieldView
    End Method
    '#End Region
End Type
