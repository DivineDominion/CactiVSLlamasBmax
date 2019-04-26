SuperStrict

Import "../View/CTController.bmx"
Import "CTBattlefield.bmx"
Import "CTBattlefieldView.bmx"
Import "CTTokenView.bmx"
Import "CTTokenSelectionController.bmx"
Import "CTTokenPositionSelectionController.bmx"

Type CTBattlefieldViewController Extends CTController
    Private
    Field battlefield:CTBattlefield
    Field battlefieldView:CTBattlefieldView

    Method New(); End Method

    Public
    Method New(battlefield:CTBattlefield)
        Self.battlefield = battlefield
        Self.battlefieldView = New CTBattlefieldView()

        AddTokenSubviews()
    End Method

    Method UpdateBattlefield()
        RemoveTokenSubviews()
        AddTokenSubviews()
    End Method

    Private
    Method AddTokenSubviews()
        For Local node:TKeyValue = EachIn Self.battlefield.TokenPositionsTokens()
            Local token:CTToken = CTToken(node.Value())
            Local position:CTTokenPosition = CTTokenPosition(node.Key())
            Local tokenView:CTTokenView = CTTokenView.CreateTokenView(token)
            tokenView.PlaceAtPosition(position)
            Self.View.AddSubview(tokenView)
        Next
    End Method

    Method RemoveTokenSubviews()
        For Local view:CTView = EachIn Self.View.AllSubviews()
            If CTTokenView(view) <> Null Then Self.View().RemoveSubview(view)
        Next
    End Method


    '#Region CTController
    Public
    Method View:CTView()
        Return Self.battlefieldView
    End Method

    Method TearDown()
        Self.TearDownSelectionControllers()
        Super.TearDown()
    End Method
    '#End Region


    '#Region Token Selection
    Private
    Field selectionControllers:TList = New TList

    Public
    Method StartSelectingTokenWithDelegate:Object(delegate:CTTokenSelectionControllerDelegate)
        Local selectionController:CTTokenSelectionController = New CTTokenSelectionController(battlefield)
        selectionController.delegate = delegate

        Self.View().AddSubview(selectionController.View())
        selectionController.MakeFirstResponder()

        Self.selectionControllers.AddLast(selectionController)

        Return selectionController
    End Method

    Method StopSelection(selection:Object)
        Local selectionController:CTBattlefieldSelectionController = CTBattlefieldSelectionController(selection)
        If Not selectionController Then Return
        Self.RemoveSelectionController(selectionController)
    End Method

    Method StartSelectingTokenPositionWithDelegate:Object(delegate:CTTokenPositionSelectionControllerDelegate)
        Local selectionController:CTTokenPositionSelectionController = New CTTokenPositionSelectionController()
        selectionController.delegate = delegate

        Self.View().AddSubview(selectionController.View())
        selectionController.MakeFirstResponder()

        Self.selectionControllers.AddLast(selectionController)

        Return selectionController
    End Method

    Private
    Method RemoveSelectionController(selectionController:CTBattlefieldSelectionController)
        Self.View.RemoveSubview(selectionController.View())
        selectionController.TearDown()
        Self.selectionControllers.Remove(selectionController)
    End Method

    Method TearDownSelectionControllers()
        For Local selectionController:CTBattlefieldSelectionController = EachIn selectionControllers
            Self.RemoveSelectionController(selectionController)
        Next
    End Method
    '#End Region
End Type
