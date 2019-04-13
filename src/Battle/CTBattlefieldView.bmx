SuperStrict

Import "../View/CTControl.bmx"
Import "../View/CTRect.bmx"
Import "CTBattlefield.bmx"
Import "CTToken.bmx"
Import "CTTokenHighlighter.bmx"

CONST BATTLEFIELD_COLUMNS% = 3
CONST BATTLEFIELD_ROWS% = 3

Interface CTBattlefieldViewDelegate
    Method BattlefieldViewDidSelectToken(battlefieldView:CTBattlefieldView, token:CTToken)
End Interface

Type CTBattlefieldView Extends CTControl
    Private
    Field battlefield:CTBattlefield
    Field tokenHighlighter:CTTokenHighlighter = New CTTokenHighlighter

    Method New(); End Method

    Public
    Field delegate:CTBattlefieldViewDelegate = Null

    Method New(battlefield:CTBattlefield)
        Self.backgroundColor = CTColor.Black()
        Self.isOpaque = True
        Self.battlefield = battlefield
    End Method

    Method TearDown()
        ResetDelegate()
        Super.TearDown()
    End Method

    Method ResetDelegate()
        Self.delegate = Null
    End Method


    '#Region CTKeyInterpreter
    Private
    Field selectedTokenPosition:CTTokenPosition = New CTTokenPosition(0, 0)

    Public
    Method ConfirmSelection()
        If Not Self.delegate Then Return
        ' FIXME: Cannot call delegate with `Self.` prefix, see: <https://github.com/bmx-ng/bcc/issues/428>
        Local selectedToken:CTToken = battlefield.TokenAtPosition(selectedTokenPosition)
        If selectedToken Then delegate.BattleFieldViewDidSelectToken(Self, selectedToken)
    End Method

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
