SuperStrict

Import "CTGameScene.bmx"
Import "../Army/CTPickParty.bmx"
Import "../View/CTScreen.bmx"
Import "CTBattleGameScene.bmx"

Type CTPickPartyGameScene Implements CTGameScene, CTPickPartyDelegate
    '#Region CTGameScene
    Private
    Field transitionDelegate:CTGameSceneTransitionDelegate = Null

    Public
    Method Activate(transitionDelegate:CTGameSceneTransitionDelegate)
        Self.transitionDelegate = transitionDelegate
        Self.PickParty()
    End Method

    Method Deactivate()
        ClosePartyPicker()
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
        _pickParty.ShowPartyPicker(Self)
    End Method

    Method ClosePartyPicker()
        If _pickParty = Null Then Return
        _pickParty.CloseWindow()
    End Method
    '#End Region


    '#Region CTPickPartyDelegate
    Public
    Method PickPartyDidPickParty(pickParty:CTPickParty, party:CTParty)
        If Not Self.transitionDelegate Then Return
        If Not party Then transitionDelegate.QuitGame()
        Local battleGameScene:CTBattleGameScene = New CTBattleGameScene(party)
        ' FIXME: Cannot call delegate with `Self.` prefix, see: <https://github.com/bmx-ng/bcc/issues/428>
         transitionDelegate.GameScenePresentsNewGameScene(Self, battleGameScene)
    End Method
    '#End Region
End Type
