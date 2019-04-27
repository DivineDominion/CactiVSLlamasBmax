SuperStrict

Import "../View/CTWindowManager.bmx"
Import "CTBattlefield.bmx"
Import "CTBattlefieldViewController.bmx"
Import "CTToken.bmx"

Rem
Call #Show() to show the window and make it key. This will display the battlefield.

Then start selection sessions on the battlefield as needed:
- Use #StartSelectingTokenWithDelegate(delegate) to select tokens from the battlefield.
- Use #StartSelectingTokenPositionWithDelegate(delegate) to select any tile on the battlefield.

You can combine both and have multiple selections active. The topmost selection
processes key events only, though, and the others remain inactive.
End Rem
Type CTBattlefieldWindowController
    Private
    Field frameRect:CTRect
    Field battlefield:CTBattlefield

    Method New(); End Method

    Public
    Method New(frameRect:CTRect, battlefield:CTBattlefield)
        Assert frameRect Else "CTBattlefieldWindowController requires frameRect"
        Assert battlefield Else "CTBattlefieldWindowController requires battlefield"
        Self.frameRect = frameRect
        Self.battlefield = battlefield
    End Method


    '#Region Window lifecycle management
    Private
    Field currentWindow:CTWindow = Null
    Field battlefieldViewController:CTBattlefieldViewController = Null

    Public
    Method Show()
        Assert Not Self.currentWindow Else "#Show called before closing the window"

        Self.battlefieldViewController = New CTBattlefieldViewController(Self.battlefield)
        Self.currentWindow = CTWindow.Create(Self.frameRect, Self.battlefieldViewController)
        CTWindowManager.GetInstance().AddWindowAndMakeKey(currentWindow)
    End Method

    Method UpdateBattlefield()
        If Not Self.battlefieldViewController Then Return
        Self.battlefieldViewController.UpdateBattlefield()
    End Method

    Method Window:CTWindow()
        Return currentWindow
    End Method

    Method Close()
        Assert Self.currentWindow Else "#Close called without active window"
        If Self.currentWindow = Null Then Return

        CTWindowManager.GetInstance().RemoveWindow(Self.currentWindow)
        Self.currentWindow = Null
        Self.battlefieldViewController = Null
    End Method
    '#End Region


    '#Region Selection Management
    Rem
    Start a new selection session that filters by tokens on the battlefield.
    Note: You can add different selections on top of each other. The latest has key status and triggers selection events.
    returns: Selection session to be used for #StopSelection(session).
    End Rem
    Method StartSelectingTokenWithDelegate:Object(delegate:CTTokenSelectionControllerDelegate)
        Assert Self.battlefieldViewController Else "Call #Show before selecting"
        Return Self.battlefieldViewController.StartSelectingTokenWithDelegate(delegate)
    End Method

    Rem
    Start a new selection session that can take any position on the battlefield.
    Note: You can add different selections on top of each other. The latest has key status and triggers selection events.
    returns: Selection session to be used for #StopSelection(session).
    End Rem
    Method StartSelectingTokenPositionWithDelegate:Object(delegate:CTTokenPositionSelectionControllerDelegate)
        Assert Self.battlefieldViewController Else "Call #Show before selecting"
        Return Self.battlefieldViewController.StartSelectingTokenPositionWithDelegate(delegate)
    End Method

    Method StopSelection(session:Object)
        Assert Self.battlefieldViewController Else "#Show CTBattlefieldWindowController before selecting"
        Self.battlefieldViewController.StopSelection(session)
    End Method
    '#End Region
End Type
