SuperStrict

import "CTRect.bmx"
import "IDrawable.bmx"

Type CTViewport
    Private
    Field contentRect:CTRect

    Public
    Function Create:CTViewport(x%, y%, w%, h%)
        Return Create(CTRect.Create(x, y, w, h))
    End Function

    Function Create:CTViewport(contentRect:CTRect)
        Local viewport:CTViewport = New CTViewport
        viewport.contentRect = contentRect
        Return viewport
    End Function

    Method Draw(drawable:IDrawable)
        If drawable = Null Then
            Return
        EndIf

        ' Cache viewport
        Local oldX%, oldY%, oldW%, oldH%
        GetViewport oldX, oldY, oldW, oldH
        ' Cache origin
        Local oldOrX#, oldOrY#
        GetOrigin oldOrX, oldOrY

        ' Set viewport to contentRect
        Local x%, y%, w%, h%
        contentRect.GetViewport(x, y, w, h)
        SetViewport x, y, w, h
        SetOrigin x-1, y-1      ' Don't know why it is 1px off without this offset

        Local contentRect:CTRect = CTRect.Create(0, 0, w, h)
        drawable.Draw(contentRect)

        ' Reset to cached values
        SetOrigin oldOrX, oldOrY
        SetViewport oldX, oldY, oldW, oldH
    End Method

End Type
