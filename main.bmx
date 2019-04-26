SuperStrict

Import "src/Logging.bmx"
Import "src/GameLoop.bmx"
Import "src/View/View.bmx"
Import "src/Game/Game.bmx"

mainLog.Append("ESC to Quit")

Local screenColor:CTColor = New CTColor(0, 0, 188)
screenColor.SetBackground()
CTView.defaultBgColor = CTColor.Black()
CTMenu.cursorImage = LoadImage("img/cursor.png")
CTMenu.checkmarkImage = LoadImage("img/checkmark.png")

Local initialScene:CTPickPartyGameScene = New CTPickPartyGameScene
Global game:CTGame = New CTGame(initialScene)

GameLoop()
