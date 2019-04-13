SuperStrict

Import "CTGameScene.bmx"

Rem
A manager of game scenes.

Conceptually, `CTGame` manages the stack of known game states just like the
responder chain of `CTResponder` objects is handled: the topmost game state
is considered to be the current one. When transitioning between game states,
`CTGame` takes care of activating and deactivating game states in memory.
This closes game state windows and pauses their background activity.
EndRem
Type CTGame Implements CTGameSceneTransitionDelegate
    Private
    Method New(); End Method

    Public
    Method New(initialGameScene:CTGameScene)
        Assert initialGameScene Else "Requires initialGameScene"
        Self.ActivateGameScene(initialGameScene)
    End Method


    '#Region CTGameSceneTransitionDelegate
    Public
    Method GameScenePresentsNewGameScene(gameScene:CTGameScene, newGameScene:CTGameScene)
        Self.ActivateGameScene(newGameScene)
    End Method

    Method QuitGame()
        End
    End Method
    '#End Region


    '#Region Game State Stack
    Private
    Global gameSceneStack:TList = New TList

    Function CurrentGameScene:CTGameScene()
        If gameSceneStack.Last() = Null Then Return Null
        Return CTGameScene(gameSceneStack.Last())
    End Function

    Method ActivateGameScene(gameScene:CTGameScene)
        Local previousGameScene:CTGameScene = CurrentGameScene()
        Self.PushGameScene(gameScene)
        If previousGameScene then previousGameScene.Deactivate()
        gameScene.Activate(Self)
    End Method

    Function PushGameScene(gameScene:CTGameScene)
        gameSceneStack.AddLast(gameScene)
    End Function

    Function PopGameScene:CTGameScene()
        ' TODO deactivate?
        If gameSceneStack.Last() = Null Then Return Null
        Return CTGameScene(gameSceneStack.RemoveLast())
    End Function
    '#End Region
End Type
