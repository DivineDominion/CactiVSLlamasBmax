SuperStrict

Import "../View/CTWindowController.bmx"
Import "../View/CTWindowManager.bmx"
Import "../Army/CTCharacter.bmx"
Import "CTActionable.bmx"
Import "CTActionStatusWindowController.bmx"

Type CTShowTurnStatus
    Private
    Field referenceFrameRect:CTRect

    Public
    Method New(referenceFrameRect:CTRect)
        Self.referenceFrameRect = referenceFrameRect
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
        If Self.actorStatusWindow Then Return
        Local frameRect:CTRect = CTWindow..
            .FrameRectFittingLines(..
                Self.referenceFrameRect.GetX(), Self.referenceFrameRect.GetMaxY(), ..
                Self.referenceFrameRect.GetWidth(), 1)..
            .Translating(0, 2)
        Self.actorStatusWindow = New CTWindow.Create(frameRect, New CTLabel())
        CTWindowManager.GetInstance().AddWindow(Self.actorStatusWindow)
    End Method
    '#End Region


    '#Region Action Status
    Private
    ' Lazy instance, access via #ActionStatusWindowController()
    Field _actionStatusWindowController:CTActionStatusWindowController = Null

    Method ActionStatusWindowController:CTActionStatusWindowController()
        If Not Self._actionStatusWindowController
            Self._actionStatusWindowController = New CTActionStatusWindowController(Self.referenceFrameRect)
        End If
        Return Self._actionStatusWindowController
    End Method

    Public
    Method ShowActionStatus(action:CTActionable)
        HideActorStatus()
        PrepareActionStatus()
        Self.ActionStatusWindowController().SetStatusText(action.GetLabel())
    End Method

    Method HideActionStatus()
        Self.ActionStatusWindowController().Close()
    End Method

    Private
    Method PrepareActionStatus()
        Self.ActionStatusWindowController().Show()
    End Method
    '#End Region
End Type
