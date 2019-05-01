SuperStrict

Import "CTDrawable.bmx"
Import "CTAnimatable.bmx"
Import "CTColor.bmx"
Import "CTViewport.bmx"

Rem
Treat `CTView` drawing as if it's the only thing on screen. The `dirtyRect`
is supposed to start at (0,0) in a viewport, so you don't need to worry about offsets.

Fills its interior with its `defaultBgColor` in `Draw(dirtyRect)` by default.

Manage view hierarchies by sending `AddSubview` to the container view, and
`RemoveFromSuperview` to the subview if it should remove itself.
EndRem
Type CTView Implements CTDrawable, CTAnimatable
    Public
    Field isOpaque:Int = True
    Global defaultBgColor:CTColor = CTColor.Blue()
    Field backgroundColor:CTColor

    Rem
    Portion of the parent view this view is limited to.
    End Rem
    Field bounds:CTRect = Null

    Method New()
        Self.backgroundColor = defaultBgColor
    End Method


    '#Region View Lifecycle
    Public
    Method TearDown()
        TearDownSubviews()
        RemoveAllSubviews()
    End Method

    Private
    Method TearDownSubviews()
        For Local subview:CTView = EachIn Self.subviews
            subview.TearDown()
        Next
    End Method
    '#End Region


    '#Region View Hierarchy
    Private
    Field subviews:TList = New TList
    Field superview:CTView = Null

    Public
    Method AddSubview:Int(subview:CTView)
        If subviews.Contains(subview) Then Return False
        subview.ViewWillMoveToSuperview(Self)
        subviews.AddLast(subview)
        subview.superview = Self
        subview.ViewDidMoveToSuperview()
        Return True
    End Method

    Method RemoveSubview:Int(subview:CTView)
        Local found:Int = subviews.Remove(subview)
        If found
            subview.ViewWillMoveToSuperview(Null)
            subview.superview = Null
            subview.ViewDidMoveToSuperview()
        End If
    End Method

    Method RemoveFromSuperview:Int()
        If Self.superview Then Return superview.RemoveSubview(Self)
        Return False
    End Method

    Method AllSubviews:CTView[]()
        Return CTView[](subviews.ToArray())
    End Method

    Method RemoveAllSubviews()
        For Local subview:CTView = EachIn Self.subviews
            Self.RemoveSubview(subview)
        Next
    End Method

    Rem
    Notifies the view that it is going to be moved to or removed from a superview.
    End Rem
    Method ViewWillMoveToSuperview(superview:CTView); End Method

    Rem
    Notifies the view that it was moved to or removed from a superview.
    Use #superview, which is now updated, to determine where it was moved.
    End Rem
    Method ViewDidMoveToSuperview(); End Method
    '#End Region


    '#Region CTDrawable
    Public
    Method Draw(dirtyRect:CTRect)
        DrawBackground(dirtyRect)
        DrawSubviews(dirtyRect)
    End Method

    Private
    Method DrawBackground(dirtyRect:CTRect)
        If Not Self.isOpaque Then Return
        If Not Self.backgroundColor Then Return

        backgroundColor.Set()
        dirtyRect.Fill()
    End Method

    Method DrawSubviews(dirtyRect:CTRect)
        For Local subview:CTView = EachIn Self.subviews
            subview.DrawInDirtyRectLimitedByBounds(dirtyRect)
        Next
    End Method

    Method DrawInDirtyRectLimitedByBounds(dirtyRect:CTRect)
        If Self.bounds
            CTViewport.Create(Self.bounds).Draw(Self)
        Else
            Self.Draw(dirtyRect)
        End If
    End Method
    '#End Region


    '#Region CTAnimatable
    Public
    Method UpdateAnimation(delta:Float)
        UpdateSubviewAnimations(delta)
    End Method

    Private
    Method UpdateSubviewAnimations(delta:Float)
        For Local subview:CTView = EachIn Self.subviews
            subview.UpdateAnimation(delta)
        Next
    End Method
    '#End Region
End Type
