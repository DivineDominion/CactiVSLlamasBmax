SuperStrict

Import "src/Logging.bmx"
Import "src/View/CTScreen.bmx"
Import "src/View/CTWindow.bmx"
Import "src/View/CTView.bmx"
Import "src/Draw.bmx"
Import "src/Battle/CTShowActionMenu.bmx"
Import "src/Battle/CTShowBattlefield.bmx"

Global mainScreen:CTScreen = CTScreen.Create(400, 400)
mainLog.Append("ESC to Quit")

Local screenColor:CTColor = CTColor.Create(128, 128, 128)
screenColor.SetCls()
CTView.defaultBgColor = CTColor.Create(0, 0, 0)
cursorImage = LoadImage("img/cursor.png")

Local logWindow:CTWindow = CreateLogWindow(mainLog)
logWindow.contentView.bgColor = CTColor.Create(64, 64, 64)
windowManager.AddWindow(logWindow)

Local windowOffset:Int = 10
Local windowWidth:Int = mainScreen.GetWidth() - (2 * windowOffset)

Local battlefieldWindowFrameRect:CTRect = CTRect.Create(windowOffset, logWindow.GetMaxY() + 2, windowWidth, 200)
Local showBattlefield:CTShowBattlefield = CTShowBattlefield.Create(battlefieldWindowFrameRect)

Local actionWindowFrameRect:CTRect = CTRect.Create(windowOffset, battlefieldWindowFrameRect.GetMaxY() + 2, windowWidth, 100)
Local showMenu:CTShowActionMenu = CTShowActionMenu.Create(actionWindowFrameRect)

showBattlefield.ShowBattlefield()
showMenu.ShowMenu()

Repeat
    mainScreen.Update(Draw)
Until KeyDown(Key_Escape) Or AppTerminate()
