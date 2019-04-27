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
        Return Self.Resizing(-2 * dx, -2 * dy).Translating(dx, dy)
    End Method

    Method Outset:CTRect(dx%, dy%)
        Return Self.Resizing(2 * dx, 2 * dy).Translating(-dx, -dy)
    End Method

    Method Translating:CTRect(dx%, dy%)
        Return CTRect.Create(Self.x + dx, Self.y + dy, Self.w, Self.h)
    End Method

    Method Resizing:CTRect(dw%, dh%)
        Return CTRect.Create(Self.x, Self.y, ..
            max(Self.w + dw, 0), max(Self.h + dh, 0))
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

    Method CenteringInContainer:CTRect(container:CTRect, arithmeticCenter:Int = False)
        Local x% = (container.GetWidth() - Self.GetWidth()) / 2
        ' Place at 2/5 of the height for tasteful centering by default, or at 50% if arithmeticCenter is on:
        Local verticalFactor# = 2.0 / 5.0
        If arithmeticCenter Then verticalFactor = 0.5
        Local y% = (container.GetHeight() - Self.GetHeight()) * verticalFactor
        Return CTRect.Create(x, y, Self.GetWidth(), Self.GetHeight())
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

    Method GetViewport(x:Int Var, y:Int Var, w:Int Var, h:Int Var)
        GetComponents(x, y, w, h)
    End Method

    Method GetComponents(x:Int Var, y:Int Var, w:Int Var, h:Int Var)
        GetOrigin(x, y)
        GetSize(w, h)
    End Method

    Method GetOrigin(x:Int Var, y:Int Var)
        x = Self.x
        y = Self.y
    End Method

    Method GetSize(w:Int Var, h:Int Var)
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
