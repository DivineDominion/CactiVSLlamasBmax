SuperStrict

Import "../View/CTControl.bmx"
Import "../View/CTRect.bmx"
Import "CTBattlefield.bmx"
Import "CTToken.bmx"
Import "CTTokenHighlighter.bmx"

Type CTBattlefieldView Extends CTControl
    Private
    Field battlefield:CTBattlefield
    Field selectionHighlighter:CTTokenHighlighter

    Method New(); End Method

    Public
    Method New(battlefield:CTBattlefield, selectionHighlighter:CTTokenHighlighter)
        Assert battlefield Else "CTBattlefieldView requires battlefield"
        Self.backgroundColor = CTColor.Black()
        Self.isOpaque = True
        Self.battlefield = battlefield
        Self.selectionHighlighter = selectionHighlighter
    End Method


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
        Self.selectionHighlighter.DrawOnBattlefield()
    End Method
    '#End Region


    '#Region CTAnimatable
    Public
    Method UpdateAnimation(delta:Float)
        Self.selectionHighlighter.UpdateAnimation(delta)
    End Method
    '#End Region
End Type
