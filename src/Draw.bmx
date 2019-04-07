SuperStrict

Import "View/CTWindowManager.bmx"

Function Update(delta:Float)
    CTWindowManager.GetInstance().UpdateAllAnimations(delta)
End Function

Function Draw:Int()
    CTWindowManager.GetInstance().DrawAllWindows()
End Function
