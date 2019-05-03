SuperStrict

Import "../View/CTView.bmx"
Import "CTTokenPosition.bmx"

Type CTBattlefieldView Extends CTView
    Const TILE_SIZE:Int = 50

    Public
    Method New()
        Self.backgroundColor = CTColor.Black()
        Self.isOpaque = True
    End Method

    Function RectForTokenPosition:CTRect(position:CTTokenPosition)
        Local x:Int = position.column * 50
        Local y:Int = position.row * 50
        Return CTRect.Create(x, y, TILE_SIZE, TILE_SIZE)
    End Function

    Function SizeForDimensions:CTRect(columns:Int, rows:Int)
        Return New CTRect(0, 0, columns * TILE_SIZE, rows * TILE_SIZE)
    End Function


    '#Region CTDrawable
    Public
    Method DrawInterior(dirtyRect:CTRect)
        Super.DrawInterior(dirtyRect)
    End Method
    '#End Region
End Type
