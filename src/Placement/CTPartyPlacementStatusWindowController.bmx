SuperStrict

Import "../View/CTWindowController.bmx"
Import "../View/CTWindowManager.bmx"
Import "CTPartyPlacementStatusViewController.bmx"

Rem
Controls the placement status label inside a window frame.
End Rem
Type CTPartyPlacementStatusWindowController Extends CTWindowController
    Private
    Field frameRect:CTRect
    Field maxCount:Int

    Method New(); End Method

    Public
    Method New(referenceFrameRect:CTRect, maxCount:Int)
        ' Place the window right below referenceFrameRect
        Self.frameRect = CTWindow..
            .FrameRectFittingLinesAndTitle(..
                referenceFrameRect.GetX(), referenceFrameRect.GetMaxY(), ..
                referenceFrameRect.GetWidth(), 1, Null)..
            .Translating(0, 2)
        Self.maxCount = maxCount
    End Method


    '#Region Window lifecycle management
    Private
    Field statusViewController:CTPartyPlacementStatusViewController = Null

    Public
    Method Show()
        Assert Not Self.currentWindow Else "#Show called before closing the window"

        Self.statusViewController = New CTPartyPlacementStatusViewController(Self.maxCount)
        Self.currentWindow = CTWindow.Create(Self.frameRect, Self.statusViewController)
        CTWindowManager.GetInstance().AddWindow(Self.currentWindow)
    End Method

    Method UpdatePlacementCount(count:Int)
        Assert Self.statusViewController Else "#UpdatePlacementCount called without active window"
        Self.statusViewController.UpdatePlacementCount(count)
    End Method

    Method Close()
        Assert Self.currentWindow Else "#Close called without active window"
        If Self.currentWindow = Null Then Return

        CTWindowManager.GetInstance().RemoveWindow(Self.currentWindow)
        Self.currentWindow = Null
        Self.statusViewController = Null
    End Method
    '#End Region
End Type
