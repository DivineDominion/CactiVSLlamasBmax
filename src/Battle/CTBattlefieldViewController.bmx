SuperStrict

Import "../View/CTController.bmx"
Import "CTBattlefield.bmx"
Import "CTBattlefieldView.bmx"
Import "CTTokenView.bmx"
Import "CTTokenSelectionController.bmx"

Interface CTBattlefieldViewControllerDelegate
    Method BattlefieldViewControllerDidSelectToken(battlefieldViewController:CTBattlefieldViewController, token:CTToken)
End Interface

Type CTBattlefieldViewController Extends CTController Implements CTTokenSelectionControllerDelegate
    Private
    Field battlefield:CTBattlefield
    Field battlefieldView:CTBattlefieldView

    Method New(); End Method

    Public
    Field delegate:CTBattlefieldViewControllerDelegate = Null

    Method New(battlefield:CTBattlefield)
        Self.battlefield = battlefield
        Self.battlefieldView = New CTBattlefieldView()

        ' Add all token subviews
        For Local node:TKeyValue = EachIn Self.battlefield.TokenPositionsTokens()
            Local token:CTToken = CTToken(node.Value())
            Local position:CTTokenPosition = CTTokenPosition(node.Key())
            Local tokenView:CTTokenView = CTTokenView.CreateTokenView(token)
            tokenView.PlaceAtPosition(position)
            Self.battlefieldView.AddSubview(tokenView)
        Next
    End Method

    Method TearDown()
        Self.TearDownSelectionControllers()
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


    '#Region Token Selection
    Private
    Field selectionControllers:TList = New TList

    Public
    Method StartSelectingToken:Object()
        Return Self.AddSelectionController()
    End Method

    Method StopSelectingToken(selection:Object)
        Local selectionController:CTTokenSelectionController = CTTokenSelectionController(selection)
        If Not selectionController Then Return
        Self.RemoveSelectionController(selectionController)
    End Method

    Private
    Method AddSelectionController:Object()
        Local selectionController:CTTokenSelectionController = New CTTokenSelectionController(battlefield)
        selectionController.delegate = Self

        Self.View().AddSubview(selectionController.View())
        selectionController.MakeHighlighterFirstResponder()

        Self.selectionControllers.AddLast(selectionController)

        Return selectionController
    End Method

    Method RemoveSelectionController(selectionController:CTTokenSelectionController)
        Self.View.RemoveSubview(selectionController.View())
        selectionController.TearDown()
        Self.selectionControllers.Remove(selectionController)
    End Method

    Method TearDownSelectionControllers()
        For Local selectionController:CTTokenSelectionController = EachIn selectionControllers
            Self.RemoveSelectionController(selectionController)
        Next
    End Method
    '#End Region

    '#Region CTTokenSelectionControllerDelegate
    Public
    Method TokenSelectionControllerDidSelectToken(controller:CTTokenSelectionController, token:CTToken)
        If Not Self.selectionControllers.Contains(controller) Then Return
        ' FIXME: Cannot call delegate with `Self.` prefix, see: <https://github.com/bmx-ng/bcc/issues/428>
        If Self.delegate Then delegate.BattlefieldViewControllerDidSelectToken(Self, token)
    End Method
    '#End Region
End Type
