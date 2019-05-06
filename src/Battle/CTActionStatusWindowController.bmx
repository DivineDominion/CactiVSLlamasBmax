SuperStrict

Import "../View/CTWindowController.bmx"
Import "../View/CTWindowManager.bmx"
Import "../View/CTLabel.bmx"

Type CTActionStatusWindowController Extends CTWindowController
    Private
    Field frameRect:CTRect

    Method New(); End Method

    Public
    Method New(referenceFrameRect:CTRect)
        ' Place the window at the position and width of referenceFrameRect
        Self.frameRect = CTWindow..
            .FrameRectFittingLines(..
                referenceFrameRect.GetX(), referenceFrameRect.GetMaxY(), ..
                referenceFrameRect.GetWidth(), 1)..
            .Translating(0, 2)
    End Method


    '#Region Window lifecycle management
    Private
    Field statusLabel:CTLabel = New CTLabel()

    Public
    Method Show()
        If Self.currentWindow Then Return

        Self.currentWindow = CTWindow.Create(Self.frameRect, Self.statusLabel)
        CTWindowManager.GetInstance().AddWindow(Self.currentWindow)
    End Method

    Method SetStatusText(text:String)
        Self.statusLabel.text = text
    End Method

    Method Close()
        If Not Self.currentWindow Then Return

        CTWindowManager.GetInstance().RemoveWindow(Self.currentWindow)
        Self.currentWindow = Null
    End Method
    '#End Region
End Type
