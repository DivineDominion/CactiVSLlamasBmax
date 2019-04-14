SuperStrict

Import "../View/CTController.bmx"
Import "CTBattlefield.bmx"
Import "CTBattlefieldView.bmx"
Import "CTTokenHighlighter.bmx"
Import "CTTokenSelectionController.bmx"

Interface CTBattlefieldViewControllerDelegate
    Method BattlefieldViewControllerDidSelectToken(battlefieldViewController:CTBattlefieldViewController, token:CTToken)
End Interface

Type CTBattlefieldViewController Extends CTController
    Private
    Field battlefield:CTBattlefield
    Field battlefieldView:CTBattlefieldView
    Field selectionController:CTTokenSelectionController

    Method New(); End Method

    Public
    Field delegate:CTBattlefieldViewControllerDelegate = Null

    Method New(battlefield:CTBattlefield)
        Self.battlefield = battlefield

        Local selectionHighlighter:CTTokenHighlighter = New CTTokenHighlighter()
        Self.selectionController = New CTTokenSelectionController(selectionHighlighter, battlefield)

        Self.battlefieldView = New CTBattlefieldView(battlefield, selectionHighlighter)
        Self.battlefieldView.keyInterpreterDelegate = Self
    End Method

    Method TearDown()
        Self.battlefieldView.TearDown()
        RemoveDelegate()
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


    '#Region CTKeyInterpreter
    Public
    Method ConfirmSelection()
        If Not Self.delegate Then Return
        ' FIXME: Cannot call delegate with `Self.` prefix, see: <https://github.com/bmx-ng/bcc/issues/428>
        Local selectedToken:CTToken = selectionController.SelectedTokenInBattlefield()
        If selectedToken Then delegate.BattlefieldViewControllerDidSelectToken(Self, selectedToken)
    End Method

    Method MoveUp()
        Self.selectionController.MoveUp()
    End Method

    Method MoveDown()
        Self.selectionController.MoveDown()
    End Method

    Method MoveLeft()
        Self.selectionController.MoveLeft()
    End Method

    Method MoveRight()
        Self.selectionController.MoveRight()
    End Method
    '#End Region
End Type
