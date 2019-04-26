SuperStrict

Import "CTGameScene.bmx"
Import "../View/View.bmx"
Import "../Battle/CTBattle.bmx"
Import "../Army/CTParty.bmx"

Type CTBattleGameScene Implements CTGameScene
    '#Region CTGameScene
    Private
    Field transitionDelegate:CTGameSceneTransitionDelegate = Null
    Field battlefield:CTBattlefield

    Public
    Method New(battlefield:CTBattlefield)
        Self.battlefield = battlefield
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
        _battle = New CTBattle(battlefieldWindowFrameRect, Self.battlefield)
        _battle.ShowBattlefield()
    End Method

    Method CloseBattlefield()
        If _battle = Null Then Return
        _battle.CloseBattlefield()
    End Method
    '#End Region
End Type
