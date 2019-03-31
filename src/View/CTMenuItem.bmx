SuperStrict

' Import "CTControl.bmx"

' Global CT_MENU_ITEM_WAS_USED:Int = AllocUserEventId("CTMenuItemWasUsed")

Type CTMenuItem

    Public
    Field label:String

    Function Create:CTMenuItem(label:String)
        Local item:CTMenuItem = New CTMenuItem
        item.label = label
        Return item
    End Function

    ' Method Use()
    '     Local didUseEvent:TEvent = CreateEvent(CT_MENU_ITEM_WAS_USED, Self)
    '     PostEvent(didUseEvent)
    ' End Method
End Type
