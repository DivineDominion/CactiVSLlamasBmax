SuperStrict

Import "CTGameScene.bmx"
Import "../View/View.bmx"
Import "../Battle/CTBattle.bmx"
Import "../Battle/CTBattleDirector.bmx"
Import "../Army/CTParty.bmx"

Type CTBattleGameScene Implements CTGameScene
    '#Region CTGameScene
    Private
    Field transitionDelegate:CTGameSceneTransitionDelegate = Null
    Field battle:CTBattle

    Public
    Method New(battle:CTBattle)
        Self.battle = battle
    End Method

    Method Activate(transitionDelegate:CTGameSceneTransitionDelegate)
        Self.transitionDelegate = transitionDelegate
        ShowBattlefield()
    End Method

    Method Deactivate()
        Self.transitionDelegate = Null
    End Method

    Private
    Field _battleDirector:CTBattleDirector = Null

    Method ShowBattlefield()
        Local windowOffset:Int = 10
        Local windowWidth:Int = CTScreen.main.GetWidth() - (2 * windowOffset)
        Local battlefieldWindowFrameRect:CTRect = CTRect.Create(windowOffset, 50, windowWidth, 200)
        _battleDirector = New CTBattleDirector(battlefieldWindowFrameRect, Self.battle)
        _battleDirector.ShowBattlefield()
        Self.battle.StartWithCharacterAnimator(_battleDirector.CharacterAnimator())
    End Method

    Method CloseBattlefield()
        If _battleDirector = Null Then Return
        _battleDirector.CloseBattlefield()
        Self.battle.Finish()
    End Method
    '#End Region
End Type
