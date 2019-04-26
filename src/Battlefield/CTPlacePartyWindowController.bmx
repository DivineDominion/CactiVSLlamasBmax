SuperStrict

Import "../View/CTWindowManager.bmx"
Import "../Army/CTParty.bmx"
Import "CTBattlefield.bmx"
Import "CTPartyPlacementViewController.bmx"
Import "CTPartyPlacementStatusViewController.bmx"

Interface CTPlacePartyDelegate
    Method PlacePartyDidPrepareBattlefield(controller:CTPlacePartyWindowController, battlefield:CTBattlefield)
End Interface

Type CTPlacePartyWindowController
    Private
    Field frameRect:CTRect
    Field party:CTParty

    Method New(); End Method

    Public
    Method New(frameRect:CTRect, party:CTParty)
        Assert frameRect Else "CTPlaceParty requires frameRect"
        Assert party Else "CTPlaceParty requires party"

        Self.frameRect = frameRect
        Self.party = party
    End Method


    '#Region Window lifecycle management
    Private
    Field delegate:CTPlacePartyDelegate = Null
    Field placementWindow:CTWindow = Null
    Field partyPlacementViewController:CTPartyPlacementViewController = Null
    Field statusWindow:CTWindow = Null
    Field statusController:CTPartyPlacementStatusViewController = Null

    Public
    Method ShowPartyPlacement(delegate:CTPlacePartyDelegate)
        Assert delegate Else "#ShowPartyPlacement requires delegate"
        Assert Not Self.placementWindow And Not Self.statusWindow Else "#ShowPartyPlacement called before closing the window"

        Self.delegate = delegate

        Self.partyPlacementViewController:CTPartyPlacementViewController = New CTPartyPlacementViewController(Self.party)
        ' partyPlacementView.delegate = Self
        Self.placementWindow = CTWindow.Create(Self.frameRect, Self.partyPlacementViewController, "Place Party on Battlefield")
        CTWindowManager.GetInstance().AddWindowAndMakeKey(Self.placementWindow)

        Local lineHeight% = TextHeight("x")
        Local statusWindowFrameRect:CTRect = CTWindow.FrameRectFittingLines(..
            Self.frameRect.GetX(), Self.frameRect.GetMaxY(), ..
            Self.frameRect.GetWidth(), 1)
        Self.statusController = New CTPartyPlacementStatusViewController(Self.party)
        Self.statusWindow = CTWindow.Create(statusWindowFrameRect, Self.statusController)
        CTWindowManager.GetInstance().AddWindow(Self.statusWindow)
    End Method

    Method CloseWindow()
        Assert Self.placementWindow And Self.statusWindow Else "#CloseWindow called without active window"

        CTWindowManager.GetInstance().RemoveWindow(Self.placementWindow)
        Self.placementWindow = Null

        CTWindowManager.GetInstance().RemoveWindow(Self.statusWindow)
        Self.statusWindow = Null

        Self.delegate = Null
    End Method
    '#End Region
End Type
