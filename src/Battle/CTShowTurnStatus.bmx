SuperStrict

Import "../Army/CTCharacter.bmx"
Import "CTActionable.bmx"
Import "CTActionStatusWindowController.bmx"
Import "CTCharacterStatusWindowController.bmx"

Type CTShowTurnStatus
    Private
    Field referenceFrameRect:CTRect

    Public
    Method New(referenceFrameRect:CTRect)
        Self.referenceFrameRect = referenceFrameRect
    End Method

    Method CloseAllStatusWindows()
        Self.CharacterStatusWindowController().Close()
        Self.ActionStatusWindowController().Close()
    End Method


    '#Region Character Status
    Private
    ' Lazy instance, use #CharacterStatusWindowController()
    Field _characterStatusWindowController:CTCharacterStatusWindowController = Null

    Method CharacterStatusWindowController:CTCharacterStatusWindowController()
        If Not _characterStatusWindowController
            Self._characterStatusWindowController = New CTCharacterStatusWindowController(Self.referenceFrameRect)
        End If
        Return Self._characterStatusWindowController
    End Method

    Public
    Method ShowCharacterStatus(character:CTCharacter)
        Self.ActionStatusWindowController().Close()
        Self.CharacterStatusWindowController().Show()
        Self.CharacterStatusWindowController().SetStatusForCharacter(character)
    End Method

    Method HideCharacterStatus()
        Self.CharacterStatusWindowController.Close()
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
        Self.CharacterStatusWindowController.Close()
        Self.ActionStatusWindowController().Show()
        Self.ActionStatusWindowController().SetStatusText(action.GetLabel())
    End Method

    Method HideActionStatus()
        Self.ActionStatusWindowController().Close()
    End Method
    '#End Region
End Type
