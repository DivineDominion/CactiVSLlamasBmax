SuperStrict

Import "CTGameScene.bmx"
Import "../Army/CTPickParty.bmx"
Import "../View/CTScreen.bmx"

Type CTPickPartyGameScene Implements CTGameScene
    '#Region CTGameScene
    Private
    Field transitionDelegate:CTGameSceneTransitionDelegate = Null

    Public
    Method Activate(transitionDelegate:CTGameSceneTransitionDelegate)
        Self.transitionDelegate = transitionDelegate
        Self.PickParty()
    End Method

    Method Deactivate()
        Self.transitionDelegate = Null
    End Method

    Private
    Field _pickParty:CTPickParty = Null

    Method PickParty()
        Local windowOffset:Int = 10
        Local windowWidth:Int = CTScreen.main.GetWidth() - (2 * windowOffset)
        Local windowHeight:Int = CTScreen.main.GetHeight() - (2 * windowOffset)
        Local frameRect:CTRect = CTRect.Create(windowOffset, windowOffset, windowWidth, windowHeight)
        _pickParty = CTPickParty.Create(frameRect, CTPlayer.cactusPlayer)
        _pickParty.ShowPartyPicker()
    End Method

    Method ClosePartyPicker()
        If _pickParty = Null Then Return
        _pickParty.CloseWindow()
    End Method
    '#End Region
End Type
