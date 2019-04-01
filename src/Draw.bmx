SuperStrict

Import "View/CTWindowManager.bmx"

Function Update(delta:Float)
    windowManager.UpdateAllAnimations(delta)
End Function

Function Draw:Int()
    windowManager.DrawAllWindows()
End Function
