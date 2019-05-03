SuperStrict

Rem
    Types that manage overall game state and game state transitions.
EndRem

Import "CTGame.bmx"

Import "CTGameScene.bmx"
Import "CTPickPartyGameScene.bmx"
Import "CTPrepareBattlefieldGameScene.bmx"
Import "CTBattleGameScene.bmx"

Public
Function InitializeGame(initialScene:CTGameScene)
    Assert Not _game Else "Only 1 instance of CTGame can exist"
    _game = New CTGame(initialScene)
End Function

Private
Global _game:CTGame
