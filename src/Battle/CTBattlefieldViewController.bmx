SuperStrict

Import "../View/CTController.bmx"
Import "CTBattlefield.bmx"
Import "CTBattlefieldView.bmx"
Import "CTTokenHighlighter.bmx"
Import "CTTokenSelectionController.bmx"

Interface CTBattlefieldViewControllerDelegate
    Method BattlefieldViewControllerDidSelectToken(battlefieldViewController:CTBattlefieldViewController, token:CTToken)
End Interface

Type CTBattlefieldViewController Extends CTController Implements CTTokenSelectionControllerDelegate
    Private
    Field battlefield:CTBattlefield
    Field battlefieldView:CTBattlefieldView
    Field selectionController:CTTokenSelectionController

    Method New(); End Method

    Public
    Field delegate:CTBattlefieldViewControllerDelegate = Null

    Method New(battlefield:CTBattlefield)
        Self.battlefield = battlefield

        Self.selectionController = New CTTokenSelectionController(battlefield)
        Self.selectionController.delegate = Self

        Self.battlefieldView = New CTBattlefieldView(battlefield)
        Self.battlefieldView.AddSubview(Self.selectionController.View())

        Self.selectionController.MakeHighlighterFirstResponder()
    End Method

    Method TearDown()
        Self.battlefieldView.TearDown()
        Self.selectionController.TearDown()
        Self.RemoveDelegate()
        Super.TearDown()
    End Method

    Method RemoveDelegate()
        Self.delegate = Null
    End Method


    '#Region CTController
    Public
    Method View:CTView()
        Return Self.battlefieldView
    End Method
    '#End Region


    '#Region CTTokenSelectionControllerDelegate
    Public
    Method TokenSelectionControllerDidSelectToken(controller:CTTokenSelectionController, token:CTToken)
        IF controller <> Self.selectionController Then Return
        ' FIXME: Cannot call delegate with `Self.` prefix, see: <https://github.com/bmx-ng/bcc/issues/428>
        If Self.delegate Then delegate.BattlefieldViewControllerDidSelectToken(Self, token)
    End Method
    '#End Region
End Type
