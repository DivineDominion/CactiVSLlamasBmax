SuperStrict

Import "../View/CTController.bmx"
Import "CTTokenHighlighter.bmx"
Import "CTBattlefield.bmx"
Import "CTTokenPosition.bmx"

Interface CTTokenSelectionControllerDelegate
    Method TokenSelectionControllerDidSelectToken(controller:CTTokenSelectionController, token:CTToken)
End Interface

Type CTTokenSelectionController Extends CTController
    Private
    Field selectionHighlighter:CTTokenHighlighter
    Field battlefield:CTBattlefield
    Field selectedTokenPosition:CTTokenPosition

    Method New(); End Method

    Public
    Field delegate:CTTokenSelectionControllerDelegate = Null

    Method New(battlefield:CTBattlefield, initialTokenPosition:CTTokenPosition = Null)
        Self.battlefield = battlefield

        Self.selectedTokenPosition = initialTokenPosition
        If Not selectedTokenPosition Then Self.selectedTokenPosition = CTTokenPosition.Origin()

        Self.selectionHighlighter = New CTTokenHighlighter()
        Self.selectionHighlighter.keyInterpreterDelegate = Self

        UpdateTokenHighlighter()
    End Method

    Method TearDown()
        Self.selectionHighlighter.TearDown()
        Self.RemoveDelegate()
        Super.TearDown()
    End Method

    Method RemoveDelegate()
        Self.delegate = Null
    End Method

    Method MakeHighlighterFirstResponder()
        Self.selectionHighlighter.MakeFirstResponder()
    End Method

    Method View:CTView()
        Return Self.selectionHighlighter
    End Method

    Method SelectedTokenInBattlefield:CTToken()
        Return Self.battlefield.TokenAtPosition(selectedTokenPosition)
    End Method


    '#Region CTKeyInterpreter
    Public
    Method ConfirmSelection()
        If Not Self.delegate Then Return
        ' FIXME: Cannot call delegate with `Self.` prefix, see: <https://github.com/bmx-ng/bcc/issues/428>
        Local selectedToken:CTToken = SelectedTokenInBattlefield()
        If selectedToken Then delegate.TokenSelectionControllerDidSelectToken(Self, selectedToken)
    End Method

    Method MoveUp()
        Self.selectedTokenPosition = selectedTokenPosition.MovedUp(BATTLEFIELD_ROWS)
        UpdateTokenHighlighter()
    End Method

    Method MoveDown()
        Self.selectedTokenPosition = selectedTokenPosition.MovedDown(BATTLEFIELD_ROWS)
        UpdateTokenHighlighter()
    End Method

    Method MoveLeft()
        Self.selectedTokenPosition = selectedTokenPosition.MovedLeft(BATTLEFIELD_COLUMNS)
        UpdateTokenHighlighter()
    End Method

    Method MoveRight()
        Self.selectedTokenPosition = selectedTokenPosition.MovedRight(BATTLEFIELD_COLUMNS)
        UpdateTokenHighlighter()
    End Method

    Private
    Method UpdateTokenHighlighter()
        ChangeHighlighterPosition()
        ResetHighlighterAnimation()
    End Method

    Method ChangeHighlighterPosition()
        Local newRect:CTRect = Self.battlefield.RectForPosition(Self.selectedTokenPosition)
        Self.selectionHighlighter.bounds = newRect
    End Method

    Method ResetHighlighterAnimation()
        Self.selectionHighlighter.ResetAnimation()
    End Method
    '#End Region
End Type