SuperStrict

Import "CTWindow.bmx"

Type CTWindowController
    Protected
    Field currentWindow:CTWindow = Null

    Public
    Method Window:CTWindow()
        Return currentWindow
    End Method
End Type
