SuperStrict

Import "CTGameScene.bmx"
Import "../Battlefield/CTPlacePartyCoordinator.bmx"
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
    Field _placePartyWindowCoordinator:CTPlacePartyCoordinator = Null

    Method PlaceParty()
        Local windowOffset:Int = 10
        Local battlefieldBounds:CTRect = CTBattlefieldView.SizeForDimensions(3+3, 3)
        Local frameRect:CTRect = CTWindow..
            .FrameRectFittingContentRect(battlefieldBounds)..
            .CenteringInContainer(CTScreen.main.GetBounds())
        _placePartyWindowCoordinator = New CTPlacePartyCoordinator(frameRect, cactusParty)
        _placePartyWindowCoordinator.ShowPartyPlacement(Self)
    End Method

    Method ClosePartyPlacement()
        If _placePartyWindowCoordinator = Null Then Return
        _placePartyWindowCoordinator.CloseWindows()
    End Method
    '#End Region


    '#Region CTPlacePartyDelegate
    Public
    Method PlacePartyDidPrepareBattlefield(controller:CTPlacePartyCoordinator, battlefield:CTBattlefield)
        If Not Self.transitionDelegate Then Return
        If Not battlefield Then transitionDelegate.QuitGame()
        Local battleGameScene:CTBattleGameScene = New CTBattleGameScene(battlefield)
        ' FIXME: Cannot call delegate with `Self.` prefix, see: <https://github.com/bmx-ng/bcc/issues/428>
         transitionDelegate.GameScenePresentsNewGameScene(Self, battleGameScene)
    End Method
    '#End Region
End Type
