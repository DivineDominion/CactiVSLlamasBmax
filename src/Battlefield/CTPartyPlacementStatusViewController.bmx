SuperStrict

Import "../Army/CTParty.bmx"
Import "../View/CTLabel.bmx"
Import "../View/CTController.bmx"

Type CTPartyPlacementStatusViewController Extends CTController
    Private
    Field maxCount:Int
    Field label:CTLabel

    Public
    Method New(maxCount:Int)
        Self.label = New CTLabel(TextSelectedCountOfMaxCount(0, Self.maxCount), True)
    End Method


    '#Region CTController
    Public
    Method View:CTView()
        Return label
    End Method
    '#End Region

    Method UpdatePlacementCount(count:Int)
        Self.label.text = TextSelectedCountOfMaxCount(count, Self.maxCount)
    End Method
End Type

Private
Function TextSelectedCountOfMaxCount:String(selected:Int, max:Int)
    Return "Selected " + String(selected) + "/" + String(max)
End Function
