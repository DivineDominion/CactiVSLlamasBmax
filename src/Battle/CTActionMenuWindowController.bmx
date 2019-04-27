SuperStrict

Import "CTActionMenuController.bmx"
Import "../View/CTRect.bmx"
Import "../View/CTWindow.bmx"
Import "../View/CTWindowManager.bmx"
Import "CTActionFactory.bmx"

Type CTActionMenuWindowController
    Private
    Field frameRect:CTRect
    Field characterName:String
    Field actions:CTActionable[]

    Method New(); End Method


    Public
    Method New(frameRect:CTRect, characterName:String, actions:CTActionable[])
        Self.frameRect = frameRect
        Self.characterName = characterName
        Self.actions = actions
    End Method


    '#Region Menu Window Lifecycle
    Private
    Field currentWindow:CTWindow = Null
    Field actionMenuController:CTActionMenuController = Null

    Public
    Method ShowMenu(delegate:CTActionMenuControllerDelegate)
        Assert Not Self.currentWindow Else "#ShowMenu called before closing the window"

        Self.actionMenuController = New CTActionMenuController(actions)
        Self.actionMenuController.delegate = delegate

        Self.currentWindow = CTWindow.Create(Self.frameRect, Self.actionMenuController, Self.characterName)
        CTWindowManager.GetInstance().AddWindowAndMakeKey(currentWindow)
    End Method

    Method CloseMenu()
        Assert Self.currentWindow Else "#CloseMenu called before showing the window"

        Self.actionMenuController.TearDown()
        Self.actionMenuController = Null

        CTWindowManager.GetInstance().RemoveWindow(Self.currentWindow)
        Self.currentWindow = Null
    End Method
    '#End Region
End Type
