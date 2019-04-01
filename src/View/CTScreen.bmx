SuperStrict

Type CTScreen
    Private
    Field width:Int
    Field height:Int

    Public

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
End Type

