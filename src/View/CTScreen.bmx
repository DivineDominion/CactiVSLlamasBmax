SuperStrict

Import "CTRect.bmx"

Type CTScreen
    Private
    Field width:Int
    Field height:Int

    Public
    Global main:CTScreen = CTScreen.Create(400, 400)

    Function Create:CTScreen(width:Int, height:Int)
        Local result:CTScreen = New CTScreen
        result.width = width
        result.height = height
        Graphics width * 2, height * 2, 0
        SetVirtualResolution width, height
        AutoImageFlags MASKEDIMAGE ' Disable smoothing
        Return result
    End Function

    Method Update(block:Int())
        Cls
        block()
        Flip
    End Method

    Method GetWidth:Int()
        Return width
    End Method

    Method GetHeight:Int()
        Return height
    End Method

    Method GetBounds:CTRect()
        Return CTRect.Create(0, 0, width, height)
    End Method
End Type

