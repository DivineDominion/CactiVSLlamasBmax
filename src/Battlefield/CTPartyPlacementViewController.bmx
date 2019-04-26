SuperStrict

Import "../View/CTController.bmx"
Import "CTBattlefieldViewController.bmx"
Import "CTBattlefieldView.bmx"
Import "../Army/CTParty.bmx"
Import "CTTokenPositionSelectionController.bmx"

Type CTPartyPlacementViewController Extends CTController Implements CTTokenPositionSelectionControllerDelegate
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

    Method TearDown()
        IF Self.selectionController Then Self.StopSelectingPosition()
        Super.TearDown()
    End Method
    '#End Region

    '#Region Token Selection
    Private
    Field selectionController:CTTokenPositionSelectionController

    Public
    Method StartSelectingPosition()
        Assert Not Self.selectionController Else "#StartSelectingPlace called with active selection"
        Self.selectionController = New CTTokenPositionSelectionController()
        Self.selectionController.delegate = Self
        Self.View().AddSubview(Self.selectionController.View())
        Self.selectionController.MakeFirstResponder()
    End Method

    Method StopSelectingPosition()
        Assert Self.selectionController Else "#StopSelectingToken called without active selection"
        Self.View.RemoveSubview(Self.selectionController.View())
        Self.selectionController.TearDown()
    End Method
    '#End Region


    '#Region CTTokenPositionSelectionControllerDelegate
    Method TokenPositionSelectionControllerDidSelectTokenPosition(controller:CTTokenPositionSelectionController, position:CTTokenPosition)
        ' TODO handle position
    End Method
    '#End Region
End Type
