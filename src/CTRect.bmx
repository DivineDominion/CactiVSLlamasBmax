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
        Local w% = max(Self.w - (dx * 2), 0)
        Local h% = max(Self.h - (dy * 2), 0)
        Return CTRect.Create(Self.x + dx, Self.y + dy, w, h)
    End Method

    Method Translate:CTRect(dx%, dy%)
        Return CTRect.Create(Self.x + dx, Self.y + dy, Self.w, Self.h)
    End Method

    Method Draw(block:Int() = Null)
        DrawRect x, y, w, h

        If block = Null Then
            Return
        EndIf

        ' Cache viewport
        Local oldX%, oldY%, oldW%, oldH%
        GetViewport oldX, oldY, oldW, oldH
        ' Cache origin
        Local oldOrX#, oldOrY#
        GetOrigin oldOrX, oldOrY

        SetViewport x, y, w, h
        SetOrigin x-1, y-1      ' Don't know why it is 1px off without this offset
        block()
        ' Reset to cached values
        SetOrigin oldOrX, oldOrY
        SetViewport oldX, oldY, oldW, oldH
    End Method

    Method GetMaxY:Int()
        Return y + h
    End Method
End Type
