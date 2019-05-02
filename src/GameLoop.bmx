SuperStrict

Import "View/CTWindowManager.bmx"
Import "View/CTScreen.bmx"
Import "Operation/CTOperationQueue.bmx"

Function Update(delta:Float)
    CTOperationQueue.Main().Update(delta)
    CTWindowManager.GetInstance().UpdateAllAnimations(delta)
End Function

Function Draw:Int()
    CTWindowManager.GetInstance().DrawAllWindows()
End Function

Function GameLoop()
    Local delta:Float = MSEC_PER_SEC / FRAME_RATE
    Local lastTime:Int = MilliSecs()

    Repeat
        Update(delta)
        CTScreen.main.Update(Draw)

        delta = MilliSecs() - lastTime
        lastTime = MilliSecs()
    Until AppTerminate()
End Function
