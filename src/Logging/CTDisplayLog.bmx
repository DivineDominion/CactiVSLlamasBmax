SuperStrict

Import "../View/DrawContrastText.bmx"

Type CTDisplayLog
    Private
    Field _log:String
    Field _lines:String[] ' derived from log


    Public
    Function Create:CTDisplayLog(initialLog:String = "")
        Local result:CTDisplayLog = New CTDisplayLog
        result.SetLog(initialLog)
        Return result
    End Function

    Method GetLines:String[]()
        Return Self._lines
    End Method

    Method GetLog:String()
        Return Self._log
    End Method

    Method SetLog(newLog:String)
        Self._log = newLog
        Self._lines = newLog.Split("\n")
    End Method

    Method Append(line:String)
        ' Replace when empty so the empty first entry is discarded
        If Self._log.length = 0 Then
            Self.SetLog(line)
            Return
        EndIf

        Local result:String = Self._log + "\n" + line
        Self.SetLog(result)
    End Method

    Method Draw(x:Int, y:Int, limit:Int = -1)
        Local lineHeight:Int = TextHeight("x")
        Local lineCount:Int = Self._lines.length
        Local lineCountStringLen:Int = String(lineCount).length
        Local lineNoWidth:Int = TextWidth(String(lineCount) + ": ")

        Local lineStart:Int = 0
        Local lineEnd:Int = lineCount
        If limit > 0 And lineCount > limit Then
            lineStart = lineCount - limit
            lineEnd = lineCount
        EndIf
        For Local lineNo:Int = lineStart Until lineEnd Step 1
            Rem
                Pad line numbers with spaces and right-align the counter:
                "  1: ..."
                "  9: ..."
                " 10: ..."
                " 99: ..."
                "100: ..."
            EndRem
            Local lineNoStringLength:Int = String(lineNo).length
            Local paddingLength:Int = lineCountStringLen - lineNoStringLength
            Local padding:String = ""
            For Local i:Int = 0 Until paddingLength Step 1
                padding = padding + " "
            Next
            Local line:String = padding + String(lineNo) + ": " + Self._lines[lineNo]

            DrawContrastText line, x, y + (lineNo - lineStart) * lineHeight
        Next
    End Method
End Type
