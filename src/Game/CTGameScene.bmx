SuperStrict

Interface CTGameSceneTransitionDelegate
    Method GameScenePresentsNewGameScene(gameScene:CTGameScene, newGameScene:CTGameScene)
End Interface

Rem
Write game scene implementations in a lightweight manner.
Each scene should be self-contained.

They are created as targets of transitions and may obtain state from the
previous scene upon creation.
End Rem
Interface CTGameScene
    Method Activate(transitionDelegate:CTGameSceneTransitionDelegate)
    Method Deactivate()
End Interface
