SuperStrict

Import "../View/CTWindowController.bmx"
Import "../View/CTWindowManager.bmx"
Import "../Army/CTCharacter.bmx"
Import "CTActionable.bmx"

Type CTShowTurnStatus
    Private
    Field statusFrameRectTemplate:CTRect

    Public
    Function CreateBelowWindowController:CTShowTurnStatus(windowController:CTWindowController)
        Assert windowController Else "CreateBelowWindowController requires windowController"
        Local referenceFrameRect:CTRect = windowController.Window().FrameRect()
        Local statusFrameRectTemplate:CTRect = referenceFrameRect..
            .Translating(0, referenceFrameRect.GetMaxY() + 2)..
        Return New CTShowTurnStatus(statusFrameRectTemplate)
    End Function

    Method New(statusFrameRectTemplate:CTRect)
        Self.statusFrameRectTemplate = statusFrameRectTemplate
    End Method


    '#Region Actor Status
    Private
    Field actorStatusWindow:CTWindow = Null

    Public
    Method ShowActorStatus(character:CTCharacter)
        HideActionStatus()
        PrepareActorStatus()
        Local label:CTLabel = CTLabel(Self.actorStatusWindow.GetContentView())
        label.text = character.GetName()
    End Method

    Method HideActorStatus()
        If Not Self.actorStatusWindow Then Return
        CTWindowManager.GetInstance().RemoveWindow(Self.actorStatusWindow)
        Self.actorStatusWindow = Null
    End Method

    Private
    Method PrepareActorStatus()
        If Self.actionStatusWindow Then Return
        Local frameRect:CTRect = CTWindow.FrameRectFittingLines(..
            statusFrameRectTemplate.GetX(), statusFrameRectTemplate.GetY(), ..
            statusFrameRectTemplate.GetWidth(), 1)
        Self.actorStatusWindow = New CTWindow.Create(frameRect, New CTLabel())
        CTWindowManager.GetInstance().AddWindow(Self.actorStatusWindow)
    End Method
    '#End Region


    '#Region Action Status
    Private
    Field actionStatusWindow:CTWindow = Null

    Public
    Method ShowActionStatus(action:CTActionable)
        HideActorStatus()
        PrepareActionStatus()
        Local label:CTLabel = CTLabel(Self.actorStatusWindow.GetContentView())
        label.text = action.GetLabel()
    End Method

    Method HideActionStatus()
        If Not Self.actionStatusWindow Then Return
        CTWindowManager.GetInstance().RemoveWindow(Self.actionStatusWindow)
        Self.actionStatusWindow = Null
    End Method

    Private
    Method PrepareActionStatus()
        If Self.actionStatusWindow Then Return
        Local frameRect:CTRect = CTWindow.FrameRectFittingLines(..
            statusFrameRectTemplate.GetX(), statusFrameRectTemplate.GetY(), ..
            statusFrameRectTemplate.GetWidth(), 1)
        Self.actionStatusWindow = New CTWindow.Create(frameRect, New CTLabel())
        CTWindowManager.GetInstance().AddWindow(Self.actionStatusWindow)
    End Method
    '#End Region
End Type
