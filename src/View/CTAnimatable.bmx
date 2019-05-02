SuperStrict

Const FRAME_RATE:Int = 60
Const MSEC_PER_SEC:Int = 1000

Interface CTAnimatable
    Method StartAnimation()
    Method IsAnimating:Int()
    Method UpdateAnimation(delta:Float)
    Method StopAnimation()
End Interface
