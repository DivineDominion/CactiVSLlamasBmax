SuperStrict

Import "../View/CTWindow.bmx"
Import "../View/CTWindowManager.bmx"
Import "CTBattlefield.bmx"
Import "CTBattlefieldViewController.bmx"
Import "CTToken.bmx"

Interface CTBattlefieldWindowControllerDelegate
    Method BattlefieldWindowControllerDidSelectToken(windowController:CTBattlefieldWindowController, token:CTToken)
End Interface

Type CTBattlefieldWindowController Implements CTBattlefieldViewControllerDelegate
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
    Field battlefieldViewController:CTBattlefieldViewController
    Field delegate:CTBattlefieldWindowControllerDelegate = Null

    Public
    Method Show(delegate:CTBattlefieldWindowControllerDelegate)
        Assert Not Self.currentWindow Else "#ShowBattlefield called before closing the window"

        Self.battlefieldViewController = New CTBattlefieldViewController(battlefield)
        Self.battlefieldViewController.delegate = Self
        Self.currentWindow = CTWindow.Create(Self.frameRect, Self.battlefieldViewController)
        CTWindowManager.GetInstance().AddWindowAndMakeKey(currentWindow)
        Self.delegate = delegate
    End Method

    Method Window:CTWindow()
        Return currentWindow
    End Method

    Method Close()
        Assert Self.currentWindow Else "#CloseWindow called without active window"
        If Self.currentWindow = Null Then Return

        Self.battlefieldViewController.TearDown()
        Self.battlefieldViewController = Null

        CTWindowManager.GetInstance().RemoveWindow(Self.currentWindow)
        Self.currentWindow.Close()
        Self.currentWindow = Null
        Self.delegate = Null
    End Method
    '#End Region


    '#Region Selection Management
    Rem
    returns: Selection session.
    End Rem
    Method StartSelectingToken:Object()
        Assert Self.battlefieldViewController Else "#Show CTBattlefieldWindowController before selecting"
        Return Self.battlefieldViewController.StartSelectingToken()
    End Method

    Method StopSelectingToken(session:Object)
        Assert Self.battlefieldViewController Else "#Show CTBattlefieldWindowController before selecting"
        Self.battlefieldViewController.StopSelectingToken(session)
    End Method
    '#End Region


    '#Region CTBattlefieldViewDelegate
    Public
    Method BattlefieldViewControllerDidSelectToken(battlefieldViewController:CTBattlefieldViewController, token:CTToken)
        If Self.battlefieldViewController <> battlefieldViewController Then Return
        ' FIXME: Cannot call delegate with `Self.` prefix, see: <https://github.com/bmx-ng/bcc/issues/428>
        If Self.delegate Then delegate.BattlefieldWindowControllerDidSelectToken(Self, token)
    End Method
    '#End Region
End Type
