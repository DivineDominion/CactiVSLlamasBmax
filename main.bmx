SuperStrict

Import "src/Logging.bmx"
Import "src/GameLoop.bmx"
Import "src/View/View.bmx"
Import "src/Game/Game.bmx"

mainLog.Append("ESC to Quit")

Local screenColor:CTColor = CTColor.Gray()
screenColor.SetCls()
CTView.defaultBgColor = CTColor.Black()
CTMenu.cursorImage = LoadImage("img/cursor.png")

Local logWindow:CTWindow = CreateLogWindow(mainLog)
CTWindowManager.GetInstance().AddWindow(logWindow)

Local battleGameScene:CTBattleGameScene = New CTBattleGameScene
Global game:CTGame = New CTGame(battleGameScene)

GameLoop()
