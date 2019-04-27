SuperStrict

Import "CTDrawable.bmx"
Import "CTAnimatable.bmx"
Import "CTColor.bmx"
Import "CTViewport.bmx"

Rem
Treat `CTView` drawing as if it's the only thing on screen. The `dirtyRect`
is supposed to start at (0,0) in a viewport, so you don't need to worry about offsets.

Fills its interior with its `defaultBgColor` in `Draw(dirtyRect)` by default.
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

    Public
    Method AddSubview:Int(subview:CTView)
        If subviews.Contains(subview) Then Return False
        subviews.AddLast(subview)
        Return True
    End Method

    Method RemoveSubview:Int(subview:CTView)
        Return subviews.Remove(subview)
    End Method

    Method AllSubviews:CTView[]()
        Return CTView[](subviews.ToArray())
    End Method

    Method RemoveAllSubviews()
        Self.subviews.Clear()
    End Method
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
