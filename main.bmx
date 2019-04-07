SuperStrict

Import "src/Logging.bmx"
Import "src/View/CTAnimatable.bmx"
Import "src/View/CTScreen.bmx"
Import "src/View/CTWindow.bmx"
Import "src/Draw.bmx"
Import "src/Battle/CTShowActionMenu.bmx"
Import "src/Battle/CTShowBattlefield.bmx"

Global mainScreen:CTScreen = CTScreen.Create(400, 400)
mainLog.Append("ESC to Quit")

Local screenColor:CTColor = CTColor.Gray()
screenColor.SetCls()
CTView.defaultBgColor = CTColor.Black()
cursorImage = LoadImage("img/cursor.png")

Local logWindow:CTWindow = CreateLogWindow(mainLog)
windowManager.AddWindow(logWindow)

Local windowOffset:Int = 10
Local windowWidth:Int = mainScreen.GetWidth() - (2 * windowOffset)

Local battlefieldWindowFrameRect:CTRect = CTRect.Create(windowOffset, logWindow.GetMaxY() + 2, windowWidth, 200)
Local showBattlefield:CTShowBattlefield = CTShowBattlefield.Instance(battlefieldWindowFrameRect)

Local actionWindowFrameRect:CTRect = CTWindow.FrameRectFittingLines(windowOffset, battlefieldWindowFrameRect.GetMaxY() + 2, windowWidth, 3)
Local showMenu:CTShowActionMenu = CTShowActionMenu.Instance(actionWindowFrameRect)

showBattlefield.ShowBattlefield()

Function GameLoop()
    Local delta:Float = MSEC_PER_SEC / FRAME_RATE
    Local lastTime:Int = MilliSecs()

    Repeat
        Update(delta)
        mainScreen.Update(Draw)

        delta = MilliSecs() - lastTime
        lastTime = MilliSecs()
    Until KeyDown(Key_Escape) Or AppTerminate()
End Function

GameLoop()
