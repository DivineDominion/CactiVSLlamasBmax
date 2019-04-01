SuperStrict

Import "../View/CTView.bmx"
Import "../View/CTRect.bmx"
Import "CTBattlefield.bmx"

Type CTBattlefieldView Extends CTView
    Private
    Field backgroundColor:CTColor = CTColor.Black()
    Field battlefield:CTBattlefield


    Public
    Method New(battlefield:CTBattlefield)
        Self.battlefield = battlefield
    End Method

    '#Region Drawing
    Public
    Method Draw(dirtyRect:CTRect)
        DrawBackdrop(dirtyRect)
        DrawTokens()
    End Method

    Private
    Method DrawBackdrop(rect:CTRect)
        Self.backgroundColor.Set()
        rect.Fill()
    End Method

    Method DrawTokens()
        Self.battlefield.DrawTokens()
    End Method
    '#End Region
End Type
