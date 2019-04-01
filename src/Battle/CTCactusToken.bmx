SuperStrict

Import "CTToken.bmx"
Import "../View/CTColor.bmx"
Import "../View/CTRect.bmx"

Type CTCactusToken Extends CTToken
    Field color:CTColor = CTColor.Create(0, 255, 0)

    Method DrawOnBattlefield(rect:CTRect)
        color.Set()
        rect.Inset(4, 4).Fill()
    End Method
End Type
