SuperStrict

Import "../View/CTView.bmx"
Import "CTBattlefield.bmx"
Import "CTToken.bmx"
Import "CTTokenHighlighter.bmx"

Type CTBattlefieldView Extends CTView
    Private
    Field battlefield:CTBattlefield

    Method New(); End Method

    Public
    Method New(battlefield:CTBattlefield)
        Assert battlefield Else "CTBattlefieldView requires battlefield"
        Self.backgroundColor = CTColor.Black()
        Self.isOpaque = True
        Self.battlefield = battlefield
    End Method


    '#Region CTDrawable
    Public
    Method Draw(dirtyRect:CTRect)
        Super.Draw(dirtyRect)
        DrawTokens()
    End Method

    Private
    Method DrawTokens()
        Self.battlefield.DrawTokens()
    End Method
    '#End Region
End Type
