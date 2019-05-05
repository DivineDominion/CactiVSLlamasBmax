SuperStrict

Import "../Event.bmx"
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

    Method New(); End Method

    Public
    Field ReadOnly battlefield:CTBattlefield

    Method New(frameRect:CTRect, battlefield:CTBattlefield)
        Assert frameRect Else "CTBattlefieldWindowController requires frameRect"
        Assert battlefield Else "CTBattlefieldWindowController requires battlefield"
        Self.frameRect = frameRect
        Self.battlefield = battlefield
    End Method


    '#Region Window lifecycle management
    Private
    Field currentWindow:CTWindow = Null
    Field currentBattlefieldViewController:CTBattlefieldViewController = Null

    Public
    Method Show()
        Assert Not Self.currentWindow Else "#Show called before closing the window"

        Self.currentBattlefieldViewController = New CTBattlefieldViewController(Self.battlefield)
        Self.currentWindow = CTWindow.Create(Self.frameRect, Self.currentBattlefieldViewController)
        CTWindowManager.GetInstance().AddWindowAndMakeKey(currentWindow)
        AddListener(Self.currentBattlefieldViewController)
    End Method

    Method BattlefieldViewController:CTBattlefieldViewController()
        Return Self.currentBattlefieldViewController
    End Method

    Method BattlefieldView:CTBattlefieldView()
        If Not Self.currentBattlefieldViewController Then Return Null
        Return Self.currentBattlefieldViewController.battlefieldView
    End Method

    Method Window:CTWindow()
        Return currentWindow
    End Method

    Method Close()
        Assert Self.currentWindow Else "#Close called without active window"
        If Self.currentWindow = Null Then Return

        CTWindowManager.GetInstance().RemoveWindow(Self.currentWindow)
        Self.currentWindow = Null

        RemoveListener(Self.currentBattlefieldViewController)
        Self.currentBattlefieldViewController = Null
    End Method
    '#End Region


    '#Region Selection Management
    Public
    Rem
    Start a new selection session that filters by tokens on the battlefield.
    Note: You can add different selections on top of each other. The latest has key status and triggers selection events.
    returns: Selection session to be used for #StopSelection(session).
    End Rem
    Method StartSelectingTokenWithDelegateAndInitialPosition:Object(..
            delegate:CTTokenSelectionControllerDelegate,..
            initialTokenPosition:CTTokenPosition)
        GuardIsVisible()
        Return Self.currentBattlefieldViewController.StartSelectingTokenWithDelegateAndInitialPosition(delegate, initialTokenPosition)
    End Method

    Rem
    Start a new selection session that can take any position on the battlefield.
    Note: You can add different selections on top of each other. The latest has key status and triggers selection events.
    returns: Selection session to be used for #StopSelection(session).
    End Rem
    Method StartSelectingTokenPositionWithDelegateAndInitialPosition:Object(..
            delegate:CTTokenPositionSelectionControllerDelegate,..
            initialTokenPosition:CTTokenPosition)
        GuardIsVisible()
        Return Self.currentBattlefieldViewController.StartSelectingTokenPositionWithDelegateAndInitialPosition(delegate, initialTokenPosition)
    End Method

    Method StopSelection(session:Object)
        GuardIsVisible()
        Self.currentBattlefieldViewController.StopSelection(session)
    End Method

    Private
    Method GuardIsVisible()
        Assert Self.currentBattlefieldViewController Else "Call #Show before selecting"
    End Method
    '#End Region
End Type
