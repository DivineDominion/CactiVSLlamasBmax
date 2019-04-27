SuperStrict

Import "CTDrivesActions.bmx"

Rem
Abstract action trait.
EndRem
Interface CTActionable
    Method GetLabel:String()

    Rem
    returns: True if executed, False if aborted.
    End Rem
    Method ExecuteInDriver:Int(driver:CTDrivesActions)
End Interface
