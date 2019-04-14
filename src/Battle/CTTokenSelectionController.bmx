SuperStrict

Import "CTTokenHighlighter.bmx"
Import "CTBattlefield.bmx"
Import "CTTokenPosition.bmx"

Type CTTokenSelectionController
    Private
    Field selectionHighlighter:CTTokenHighlighter
    Field battlefield:CTBattlefield
    Field selectedTokenPosition:CTTokenPosition

    Method New(); End Method

    Public
    Method New(selectionHighlighter:CTTokenHighlighter, battlefield:CTBattlefield, initialTokenPosition:CTTokenPosition = Null)
        Self.selectionHighlighter = selectionHighlighter
        Self.battlefield = battlefield
        Self.selectedTokenPosition = initialTokenPosition
        If Not selectedTokenPosition Then Self.selectedTokenPosition = CTTokenPosition.Origin()

        UpdateTokenHighlighter()
    End Method

    Method SelectedTokenInBattlefield:CTToken()
        Return battlefield.TokenAtPosition(selectedTokenPosition)
    End Method


    '#Region Movement
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
        Self.selectionHighlighter.ChangeTokenRect(newRect)
    End Method

    Method ResetHighlighterAnimation()
        Self.selectionHighlighter.ResetAnimation()
    End Method
    '#End Region
End Type