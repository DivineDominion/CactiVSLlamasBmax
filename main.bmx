SuperStrict

Import "src/Logging.bmx"
Import "src/View/CTScreen.bmx"
Import "src/View/CTWindow.bmx"
Import "src/View/CTView.bmx"
Import "src/Draw.bmx"
Import "src/View/CTMenu.bmx"

Global mainScreen:CTScreen = CTScreen.Create(400, 400)
mainLog.Append("ESC to Quit")

Local screenColor:CTColor = CTColor.Create(128, 128, 128)
screenColor.SetCls()

CTView.defaultBgColor = CTColor.Create(0, 0, 0)

Type CTTestView Extends CTView
    Method Draw(dirtyRect:CTRect)
        Super.Draw(dirtyRect)
        SetColor 255,255,0
        SetLineWidth 1
        Local size:Int = min(dirtyRect.GetWidth(), dirtyRect.GetHeight()) - 2
        DrawRect 1, 1, size, size
    End Method
End Type

Local logWindow:CTWindow = CreateLogWindow(mainLog)
logWindow.contentView.bgColor = CTColor.Create(64, 64, 64)
windowManager.AddWindow(logWindow)

Local windowOffset:Int = 10
Local windowWidth:Int = mainScreen.GetWidth() - (2 * windowOffset)

Local characterWindow:CTWindow = CTWindow.Create(windowOffset, logWindow.GetMaxY() + 2, windowWidth, 200)
characterWindow.ReplaceContentView(New CTTestView())
windowManager.AddWindow(characterWindow)

cursorImage = LoadImage("img/cursor.png")
Local actionWindow:CTWindow = CTWindow.Create(windowOffset, characterWindow.GetMaxY() + 2, windowWidth, 100)
Local actionMenu:CTMenu = CTMenu.Create(["Fight", "Run"])
actionWindow.ReplaceContentView(actionMenu)
windowManager.AddWindow(actionWindow)

Repeat
    mainScreen.Update(Draw)
Until KeyDown(Key_Escape) Or AppTerminate()
