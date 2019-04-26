SuperStrict

Import "../View/CTWindowManager.bmx"
Import "../Army/CTParty.bmx"
Import "CTBattlefield.bmx"
Import "CTPartyPlacementStatusWindowController.bmx"
Import "CTBattlefieldWindowController.bmx"

Interface CTPlacePartyDelegate
    Method PlacePartyDidPrepareBattlefield(controller:CTPlacePartyCoordinator, battlefield:CTBattlefield)
End Interface

Rem
Puts multiple windows on the screen and manages the selection and placement of
tokens on the battlefield.
End Rem
Type CTPlacePartyCoordinator Implements CTTokenPositionSelectionControllerDelegate
    Private
    Field frameRect:CTRect
    Field party:CTParty
    Field battlefield:CTBattlefield

    Method New(); End Method

    Public
    Method New(frameRect:CTRect, party:CTParty)
        Assert frameRect Else "CTPlacePartyCoordinator requires frameRect"
        Assert party Else "CTPlacePartyCoordinator requires party"

        Self.frameRect = frameRect
        Self.party = party
        Self.battlefield = New CTBattlefield()
    End Method


    '#Region Window lifecycle management
    Private
    Field delegate:CTPlacePartyDelegate = Null
    Field battlefieldWindowController:CTBattlefieldWindowController = Null
    Field statusWindowController:CTPartyPlacementStatusWindowController = Null
    Field selectionSession:Object = Null

    Public
    Method ShowPartyPlacement(delegate:CTPlacePartyDelegate)
        Assert delegate Else "#ShowPartyPlacement requires delegate"
        Assert Not Self.battlefieldWindowController And Not Self.statusWindowController Else "#ShowPartyPlacement called before closing the window"

        Self.delegate = delegate

        Self.battlefieldWindowController = New CTBattlefieldWindowController(Self.frameRect, Self.battlefield)
        Self.battlefieldWindowController.Show()

        Self.statusWindowController = New CTPartyPlacementStatusWindowController(Self.frameRect, Self.party.Count())
        Self.statusWindowController.Show()

        ' Start selecting
        Self.selectionSession = Self.battlefieldWindowController.StartSelectingTokenPositionWithDelegate(Self)
    End Method

    Method CloseWindows()
        Assert Self.battlefieldWindowController Else "#CloseWindows called without active battlefieldWindowController"
        Assert Self.statusWindowController Else "#CloseWindows called without active statusWindowController"

        Self.battlefieldWindowController.Close()
        Self.battlefieldWindowController = Null

        Self.statusWindowController.Close()
        Self.statusWindowController = Null

        Self.delegate = Null
    End Method
    '#End Region


    '#Region CTTokenPositionSelectionControllerDelegate
    Method TokenPositionSelectionControllerDidSelectTokenPosition(controller:CTTokenPositionSelectionController, position:CTTokenPosition)
        ' TODO pick character from list
        ' TODO place token for character at position
    End Method
    '#End Region
End Type
