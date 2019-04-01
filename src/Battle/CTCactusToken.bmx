SuperStrict

Import "../View/CTColor.bmx"
Import "../View/CTRect.bmx"
Import "CTBattlefield.bmx"

Type CTCactusDrawing
    Field color:CTColor = CTColor.Create(0, 255, 0)

    Method Draw(rect:CTRect)
        color.Set()
        rect.Inset(4, 4).Fill()
    End Method
End Type

Type CTCactusToken Extends CTToken
    Field drawing:CTCactusDrawing = New CTCactusDrawing

    ' FIXME: Duplicate constructor needed because of https://github.com/bmx-ng/bcc/issues/417
    Method New(position:CTTokenPosition)
        Self.position = position
    End Method

    Method Draw(battlefield:CTBattlefield)
        Local rect:CTRect = battlefield.RectForPosition(position)
        drawing.Draw(rect)
    End Method
End Type


