SuperStrict

Import "CTGameScene.bmx"
Import "../Battlefield/CTPlacePartyWindowController.bmx"
Import "../Battlefield/CTBattlefieldView.bmx"
Import "../View/CTScreen.bmx"
Import "../Game/CTPlayer.bmx"
Import "CTBattleGameScene.bmx"

Type CTPrepareBattlefieldGameScene Implements CTGameScene, CTPlacePartyDelegate
    Private
    Field cactusParty:CTParty

    Public
    Method New(cactusParty:CTParty)
        Self.cactusParty = cactusParty
    End Method


    '#Region CTGameScene
    Private
    Field transitionDelegate:CTGameSceneTransitionDelegate = Null

    Public
    Method Activate(transitionDelegate:CTGameSceneTransitionDelegate)
        Self.transitionDelegate = transitionDelegate
        Self.PlaceParty()
    End Method

    Method Deactivate()
        ClosePartyPlacement()
        Self.transitionDelegate = Null
    End Method

    Private
    Field _placePartyWindowController:CTPlacePartyWindowController = Null

    Method PlaceParty()
        Local windowOffset:Int = 10
        Local battlefieldBounds:CTRect = CTBattlefieldView.SizeForDimensions(3+3, 3)
        Local frameRect:CTRect = CTWindow..
            .FrameRectFittingContentRect(battlefieldBounds)..
            .CenteringInContainer(CTScreen.main.GetBounds())
        _placePartyWindowController = New CTPlacePartyWindowController(frameRect, cactusParty)
        _placePartyWindowController.ShowPartyPlacement(Self)
    End Method

    Method ClosePartyPlacement()
        If _placePartyWindowController = Null Then Return
        _placePartyWindowController.CloseWindow()
    End Method
    '#End Region


    '#Region CTPlacePartyDelegate
    Public
    Method PlacePartyDidPrepareBattlefield(controller:CTPlacePartyWindowController, battlefield:CTBattlefield)
        If Not Self.transitionDelegate Then Return
        If Not battlefield Then transitionDelegate.QuitGame()
        Local battleGameScene:CTBattleGameScene = New CTBattleGameScene(battlefield)
        ' FIXME: Cannot call delegate with `Self.` prefix, see: <https://github.com/bmx-ng/bcc/issues/428>
         transitionDelegate.GameScenePresentsNewGameScene(Self, battleGameScene)
    End Method
    '#End Region
End Type
