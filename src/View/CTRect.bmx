SuperStrict

Type CTRect
    Private
    Field x%, y%, w%, h%

    Public
    Function Create:CTRect(x%, y%, w%, h%)
        Local rect:CTRect = New CTRect
        rect.x = x
        rect.y = y
        rect.w = w
        rect.h = h
        Return rect
    End Function

    Method Inset:CTRect(dx%, dy%)
        Local w% = max(Self.w - (2 * dx), 0)
        Local h% = max(Self.h - (2 * dy), 0)
        Return CTRect.Create(Self.x + dx, Self.y + dy, w, h)
    End Method

    Method Translate:CTRect(dx%, dy%)
        Return CTRect.Create(Self.x + dx, Self.y + dy, Self.w, Self.h)
    End Method

    Method Fill()
        DrawRect x, y, w, h
    End Method

    Method GetViewport(x:Int Var, y:Int Var, w:Int Var, h:Int Var)
        x = Self.x
        y = Self.y
        w = Self.w
        h = Self.h
    End Method

    Method GetX:Int()
        Return x
    End Method

    Method GetY:Int()
        Return y
    End Method

    Method GetWidth:Int()
        Return w
    End Method

    Method GetHeight:Int()
        Return h
    End Method

    Method GetMaxX:Int()
        Return x + w
    End Method

    Method GetMaxY:Int()
        Return y + h
    End Method

End Type
