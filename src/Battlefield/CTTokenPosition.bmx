SuperStrict

Type CTTokenPosition
    Function Origin:CTTokenPosition()
        Return New CTTokenPosition(0, 0)
    End Function

    Field column%, row%

    Method New(column%, row%)
        Assert column >= 0 Else "column negative"
        Assert row >= 0 Else "row negative"
        Self.column = column
        Self.row = row
    End Method

    Method Compare:Int(other:Object)
        Local otherPosition:CTTokenPosition = CTTokenPosition(other)
        If Not otherPosition Then Return Super.Compare(other)

        If Self.column < otherPosition.column
            Return -1
        Else If Self.column > otherPosition.column
            Return 1
        Else ' ==
            If Self.row = otherPosition.row Then Return 0
            If Self.row < otherPosition.row Then Return -1
            If Self.row > otherPosition.row Then Return 1
        End If
    End Method

    Method IsEqual:Int(other:CTTokenPosition)
        Return (Compare(other) = 0)
    End Method

    Method MovedRight:CTTokenPosition(limit%)
        Local newColumn% = column + 1
        If newColumn < limit Then Return New CTTokenPosition(newColumn, row)
        Return New CTTokenPosition(0, row)
    End Method

    Method MovedLeft:CTTokenPosition(limit%)
        Local newColumn% = column - 1
        If newColumn < 0 Then Return New CTTokenPosition(limit - 1, row)
        Return New CTTokenPosition(newColumn, row)
    End Method

    Method MovedDown:CTTokenPosition(limit%)
        Local newRow% = row + 1
        If newRow < limit Then Return New CTTokenPosition(column, newRow)
        Return New CTTokenPosition(column, 0)
    End Method

    Method MovedUp:CTTokenPosition(limit%)
        Local newRow% = row - 1
        If newRow < 0 Then Return New CTTokenPosition(column, limit - 1)
        Return New CTTokenPosition(column, newRow)
    End Method
End Type
