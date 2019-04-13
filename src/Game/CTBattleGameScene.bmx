SuperStrict

Import "CTGameScene.bmx"
Import "../View/View.bmx"
Import "../Battle/CTBattle.bmx"

Type CTBattleGameScene Implements CTGameScene
    '#Region CTGameScene
    Private
    Field transitionDelegate:CTGameSceneTransitionDelegate = Null
    Field cactusParty:TList

    Public
    Method New(cactusParty:TList)
        Self.cactusParty = cactusParty
    End Method

    Method Activate(transitionDelegate:CTGameSceneTransitionDelegate)
        Self.transitionDelegate = transitionDelegate
        ShowBattlefield()
    End Method

    Method Deactivate()
        Self.transitionDelegate = Null
    End Method

    Private
    Field _showBattlefield:CTBattle = Null

    Method ShowBattlefield()
        Local windowOffset:Int = 10
        Local windowWidth:Int = CTScreen.main.GetWidth() - (2 * windowOffset)
        Local battlefieldWindowFrameRect:CTRect = CTRect.Create(windowOffset, 50, windowWidth, 200)
        _showBattlefield:CTBattle = New CTBattle(battlefieldWindowFrameRect, CTCactus[](cactusParty.ToArray()))
        _showBattlefield.ShowBattlefield()
    End Method

    Method CloseBattlefield()
        If _showBattlefield = Null Then Return
        _showBattlefield.CloseWindow()
    End Method
    '#End Region

End Type
