SuperStrict

Import "../View/CTLabel.bmx"
Import "../View/CTController.bmx"

Type CTPartyPlacementStatusViewController Extends CTController
    Private
    Field maxCount:Int
    Field label:CTLabel

    Method New(); End Method


    Public
    Method New(maxCount:Int)
        Self.label = New CTLabel(TextSelectedCountOfMaxCount(0, Self.maxCount), True)
    End Method

    Method UpdatePlacementCount(count:Int)
        Self.label.text = TextSelectedCountOfMaxCount(count, Self.maxCount)
    End Method


    '#Region CTController
    Public
    Method View:CTView()
        Return Self.label
    End Method
    '#End Region
End Type

Private
Function TextSelectedCountOfMaxCount:String(selected:Int, max:Int)
    Return "Placed " + String(selected) + "/" + String(max) + " Party Members"
End Function
