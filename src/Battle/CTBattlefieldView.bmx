SuperStrict

Import "../View/CTView.bmx"
Import "CTTokenPosition.bmx"

Type CTBattlefieldView Extends CTView
    Public
    Method New()
        Self.backgroundColor = CTColor.Black()
        Self.isOpaque = True
    End Method

    Function RectForTokenPosition:CTRect(position:CTTokenPosition)
        Local x:Int = position.column * 50
        Local y:Int = position.row * 50
        Return CTRect.Create(x, y, 50, 50)
    End Function


    '#Region CTDrawable
    Public
    Method Draw(dirtyRect:CTRect)
        Super.Draw(dirtyRect)
    End Method
    '#End Region
End Type
