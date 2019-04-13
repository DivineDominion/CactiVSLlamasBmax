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
    Field _battle:CTBattle = Null

    Method ShowBattlefield()
        Local windowOffset:Int = 10
        Local windowWidth:Int = CTScreen.main.GetWidth() - (2 * windowOffset)
        Local battlefieldWindowFrameRect:CTRect = CTRect.Create(windowOffset, 50, windowWidth, 200)
        Local cacti:CTCactus[] = CTCactus[](cactusParty.ToArray())
        _battle:CTBattle = New CTBattle(battlefieldWindowFrameRect, cacti)
        _battle.ShowBattlefield()
    End Method

    Method CloseBattlefield()
        If _battle = Null Then Return
        _battle.CloseBattlefield()
    End Method
    '#End Region
End Type
