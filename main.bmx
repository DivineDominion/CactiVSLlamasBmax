SuperStrict

Import "src/Logging.bmx"
Import "src/Battle/CTShowBattlefield.bmx"
Import "src/GameLoop.bmx"
Import "src/View/View.bmx"

mainLog.Append("ESC to Quit")

Local screenColor:CTColor = CTColor.Gray()
screenColor.SetCls()
CTView.defaultBgColor = CTColor.Black()
CTMenu.cursorImage = LoadImage("img/cursor.png")

Local logWindow:CTWindow = CreateLogWindow(mainLog)
CTWindowManager.GetInstance().AddWindow(logWindow)

Local windowOffset:Int = 10
Local windowWidth:Int = mainScreen.GetWidth() - (2 * windowOffset)

Local battlefieldWindowFrameRect:CTRect = CTRect.Create(windowOffset, logWindow.GetMaxY() + 2, windowWidth, 200)
Local showBattlefield:CTShowBattlefield = CTShowBattlefield.Instance(battlefieldWindowFrameRect)

Local actionWindowFrameRect:CTRect = CTWindow.FrameRectFittingLines(windowOffset, battlefieldWindowFrameRect.GetMaxY() + 2, windowWidth, 3)

showBattlefield.ShowBattlefield()

GameLoop()
