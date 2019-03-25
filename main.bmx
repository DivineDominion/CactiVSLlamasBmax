SuperStrict

Import "src/Logging.bmx"
Import "src/View/CTScreen.bmx"
Import "src/View/CTWindow.bmx"
Import "src/View/CTView.bmx"
Import "src/Draw.bmx"

Global mainScreen:CTScreen = CTScreen.Create(400, 400)
mainLog.Append("ESC to Quit")

Local bgColor:CTColor = CTColor.Create(128, 128, 128)
bgColor.SetCls()
CTView.defaultBgColor = bgColor

Type CTTestView Extends CTView
    Method Draw(dirtyRect:CTRect)
        Super.Draw(dirtyRect)
        SetColor 255,255,0
        SetLineWidth 1
        DrawLine 0,0,100,100
    End Method
End Type

Local logWindow:CTWindow = CreateLogWindow(mainLog)
Local characterWindow:CTWindow = CTWindow.Create(10, logWindow.GetMaxY() + 2, 380, 100, New CTTestView())

Repeat
    mainScreen.Update(Draw)
Until KeyDown(Key_Escape) Or AppTerminate()
