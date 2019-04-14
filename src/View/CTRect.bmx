SuperStrict

Type CTRect
    Private
    Field x%, y%, w%, h%

    Public
    Method New(x%, y%, w%, h%)
        Self.x = x
        Self.y = y
        Self.w = w
        Self.h = h
    End Method

    Method Copy:CTRect()
        Return New CTRect(x, y, w, h)
    End Method

    Function Create:CTRect(x%, y%, w%, h%)
        Return New CTRect(x, y, w, h)
    End Function

    Method Inset:CTRect(dx%, dy%)
        Local w% = max(Self.w - (2 * dx), 0)
        Local h% = max(Self.h - (2 * dy), 0)
        Return CTRect.Create(Self.x + dx, Self.y + dy, w, h)
    End Method

    Method Translating:CTRect(dx%, dy%)
        Return CTRect.Create(Self.x + dx, Self.y + dy, Self.w, Self.h)
    End Method

    Method Resizing:CTRect(dw%, dh%)
        Return CTRect.Create(Self.x, Self.y, Self.w + dw, Self.h + dh)
    End Method

    Method SettingSize:CTRect(newWidth%, newHeight%)
        Return CTRect.Create(Self.x, Self.y, newWidth, newHeight)
    End Method

    Method SettingHeight:CTRect(newHeight%)
        Return CTRect.Create(Self.x, Self.y, Self.w, newHeight)
    End Method

    Method SettingWidth:CTRect(newWidth%)
        Return CTRect.Create(Self.x, Self.y, newWidth, Self.h)
    End Method

    Method Fill()
        DrawRect x, y, w, h
    End Method

    Method Stroke(strokeWidth:Int=1)
        DrawRect x, y, w, strokeWidth
        DrawRect x, y, strokeWidth, h
        DrawRect x+w-strokeWidth, y, strokeWidth, h
        DrawRect x, y+h-strokeWidth, w, strokeWidth
    End Method

    Method GetComponents(x:Int Var, y:Int Var, w:Int Var, h:Int Var)
        x = Self.x
        y = Self.y
        w = Self.w
        h = Self.h
    End Method

    Method GetViewport(x:Int Var, y:Int Var, w:Int Var, h:Int Var)
        GetComponents(x, y, w, h)
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
