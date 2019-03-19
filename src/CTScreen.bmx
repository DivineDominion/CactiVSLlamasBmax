SuperStrict

Type CTScreen
    Field width:Int
    Field height:Int

    Function Create:CTScreen(width:Int, height:Int)
        Local result:CTScreen = New CTScreen
        result.width = width
        result.height = height
        Graphics width, height, 0
        Return result
    End Function
End Type
