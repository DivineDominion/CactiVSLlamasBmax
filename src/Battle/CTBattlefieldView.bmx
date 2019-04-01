SuperStrict

Import "../View/CTView.bmx"
Import "../View/CTRect.bmx"
Import "CTBattlefield.bmx"
Import "CTTokenHighlighter.bmx"

Type CTBattlefieldView Extends CTView
    Private
    Field backgroundColor:CTColor = CTColor.Black()
    Field battlefield:CTBattlefield
    Field tokenHighlighter:CTTokenHighlighter = New CTTokenHighlighter


    Public
    Method New(battlefield:CTBattlefield)
        Self.battlefield = battlefield
    End Method

    '#Region Drawing
    Public
    Method Draw(dirtyRect:CTRect)
        DrawBackdrop(dirtyRect)
        DrawTokens()
        DrawTokenHighlighter()
    End Method

    Private
    Method DrawBackdrop(rect:CTRect)
        Self.backgroundColor.Set()
        rect.Fill()
    End Method

    Method DrawTokens()
        Self.battlefield.DrawTokens()
    End Method

    Method DrawTokenHighlighter()
        Local highlighterRect:CTRect = Self.battleField.RectForColumnRow(0, 0)
        Self.tokenHighlighter.DrawOnBattlefield(highlighterRect)
    End Method
    '#End Region
End Type
