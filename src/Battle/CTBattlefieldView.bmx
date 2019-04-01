SuperStrict

Import "../View/CTControl.bmx"
Import "../View/CTRect.bmx"
Import "CTBattlefield.bmx"
Import "CTTokenHighlighter.bmx"

CONST BATTLEFIELD_COLUMNS% = 3
CONST BATTLEFIELD_ROWS% = 3

Type CTBattlefieldView Extends CTControl
    Private
    Field battlefield:CTBattlefield
    Field tokenHighlighter:CTTokenHighlighter = New CTTokenHighlighter


    Public
    Method New()
        Self.backgroundColor = CTColor.Black()
        Self.isOpaque = True
    End Method

    Method New(battlefield:CTBattlefield)
        New()
        Self.battlefield = battlefield
    End Method

    '#Region CTKeyInterpreter
    Public
    Method MoveUp()
        Self.selectedTokenPosition = selectedTokenPosition.MovedUp(BATTLEFIELD_ROWS)
        ResetTokenHighlighterAnimation()
    End Method

    Method MoveDown()
        Self.selectedTokenPosition = selectedTokenPosition.MovedDown(BATTLEFIELD_ROWS)
        ResetTokenHighlighterAnimation()
    End Method

    Method MoveLeft()
        Self.selectedTokenPosition = selectedTokenPosition.MovedLeft(BATTLEFIELD_COLUMNS)
        ResetTokenHighlighterAnimation()
    End Method

    Method MoveRight()
        Self.selectedTokenPosition = selectedTokenPosition.MovedRight(BATTLEFIELD_COLUMNS)
        ResetTokenHighlighterAnimation()
    End Method

    Private
    Field selectedTokenPosition:CTTokenPosition = New CTTokenPosition(0, 0)

    Method ResetTokenHighlighterAnimation()
        Self.tokenHighlighter.ResetAnimation()
    End Method
    '#End Region

    '#Region CTDrawable
    Public
    Method Draw(dirtyRect:CTRect)
        Super.Draw(dirtyRect)
        DrawTokens()
        DrawTokenHighlighter()
    End Method

    Private
    Method DrawTokens()
        Self.battlefield.DrawTokens()
    End Method

    Method DrawTokenHighlighter()
        Local highlighterRect:CTRect = Self.battleField.RectForPosition(Self.selectedTokenPosition)
        Self.tokenHighlighter.DrawOnBattlefield(highlighterRect)
    End Method
    '#End Region

    '#Region CTAnimatable
    Public
    Method UpdateAnimation(delta:Float)
        Self.tokenHighlighter.UpdateAnimation(delta)
    End Method
    '#End Region
End Type
