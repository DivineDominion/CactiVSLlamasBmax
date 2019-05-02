SuperStrict

Import "../Event.bmx"
Import "CTOperation.bmx"
Import "../View/CTAnimatable.bmx"

Rem
Concurrent/non-blocking operation that finishes when its animation fires the "AnimationDidComplete" event.
End Rem
Type CTAnimationOperation Extends CTOperation Final
    Private
    Field animation:CTAnimatable

    Method New(); End Method

    Public
    Method New(animation:CTAnimatable)
        Self.animation = animation
    End Method


    '#Region CTOperation
    Method Main:Int()
        ' Run until animation finishes
        AddListener(Self)
        Self.animation.StartAnimation()
        Return ONGOING
    End Method

    ' FIXME: expect :CTAnimatable when <https://github.com/bmx-ng/bcc/issues/437> is implemented
    Method OnAnimationDidComplete(animatable:Object)
        If animatable <> Self.animation Then Return
        RemoveListener(Self)
        Self.animation.StopAnimation()
        Self.Finish()
    End Method
    '#End Region
End Type
