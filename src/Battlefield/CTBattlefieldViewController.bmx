SuperStrict

Import "../Event.bmx"
Import "../View/CTController.bmx"
Import "CTBattlefield.bmx"
Import "CTBattlefieldView.bmx"
Import "CTTokenView.bmx"
Import "CTTokenSelectionController.bmx"
Import "CTTokenPositionSelectionController.bmx"

Type CTBattlefieldViewController Extends CTController
    Private
    Field battlefield:CTBattlefield

    Method New(); End Method

    Public
    Field ReadOnly battlefieldView:CTBattlefieldView

    Method New(battlefield:CTBattlefield)
        Self.battlefield = battlefield
        Self.battlefieldView = New CTBattlefieldView()

        AddAllTokenSubviews()
    End Method

    Method OnBattlefieldDidRemoveToken(battlefield:CTBattlefield, battlefieldChange:CTBattlefieldChange)
        RemoveTokenSubviewForToken(battlefieldChange.token)
    End Method

    Method OnBattlefieldDidAddToken(battlefield:CTBattlefield, battlefieldChange:CTBattlefieldChange)
        AddTokenSubviewForTokenAtTokenPosition(battlefieldChange.token, battlefieldChange.tokenPosition)
    End Method

    Private
    Method AddAllTokenSubviews()
        For Local node:TKeyValue = EachIn Self.battlefield.TokenPositionsTokens()
            Local token:CTToken = CTToken(node.Value())
            Local tokenPosition:CTTokenPosition = CTTokenPosition(node.Key())
            Self.AddTokenSubviewForTokenAtTokenPosition(token, tokenPosition)
        Next
    End Method

    Method RemoveTokenSubviewForToken(token:CTToken)
        Local tokenView:CTTokenView = Self.battlefieldView.TokenViewForToken(token)
        If Not tokenView Then Return
        tokenView.TearDown()
        tokenView.RemoveFromSuperview()
    End Method

    Method AddTokenSubviewForTokenAtTokenPosition(token:CTToken, tokenPosition:CTTokenPosition)
        Local tokenView:CTTokenView = CTTokenView.CreateTokenView(token)
        tokenView.bounds = CTBattlefieldView.RectForTokenPosition(tokenPosition)
        Self.battlefieldView.AddSubview(tokenView)
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
    Method StartSelectingTokenWithDelegateAndInitialPosition:Object(..
            delegate:CTTokenSelectionControllerDelegate,..
            initialTokenPosition:CTTokenPosition = Null)
        Local selectionController:CTTokenSelectionController = CTTokenSelectionController.Create(battlefield, initialTokenPosition)
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

    Method StartSelectingTokenPositionWithDelegateAndInitialPosition:Object(..
            delegate:CTTokenPositionSelectionControllerDelegate,..
            initialTokenPosition:CTTokenPosition = Null)
        Local selectionController:CTTokenPositionSelectionController = CTTokenPositionSelectionController.Create(initialTokenPosition)
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
