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


    '#Region Game State Stack
    Private
    Global gameSceneStack:TList = New TList

    Function CurrentGameScene:CTGameScene()
        If gameSceneStack.Last() = Null Then Return Null
        Return CTGameScene(gameSceneStack.Last())
    End Function

    Method ActivateGameScene(gameState:CTGameScene)
        Self.PushGameScene(gameState)
        gameState.Activate(Self)
    End Method

    Function PushGameScene(gameState:CTGameScene)
        gameSceneStack.AddLast(gameState)
    End Function

    Function PopGameScene:CTGameScene()
        If gameSceneStack.Last() = Null Then Return Null
        Return CTGameScene(gameSceneStack.RemoveLast())
    End Function
    '#End Region
End Type
