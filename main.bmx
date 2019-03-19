SuperStrict

import "src/CTScreen.bmx"


Local mainScreen:CTScreen = CTScreen.Create(800, 800)

Repeat
    Cls

    DrawText "Hello", 10, 10

    Flip
Until KeyDown(Key_Escape)
