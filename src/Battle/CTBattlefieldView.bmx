SuperStrict

Import "../View/CTView.bmx"
Import "../View/CTRect.bmx"
Import "CTBattlefield.bmx"
Import "CTTokenHighlighter.bmx"

Type CTBattlefieldView Extends CTView
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

    '#Region Drawing
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
        Local highlighterRect:CTRect = Self.battleField.RectForColumnRow(0, 0)
        Self.tokenHighlighter.DrawOnBattlefield(highlighterRect)
    End Method
    '#End Region
End Type
