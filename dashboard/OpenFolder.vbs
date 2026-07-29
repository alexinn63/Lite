Option Explicit

Dim uri, encoded, path

If WScript.Arguments.Count < 1 Then
    WScript.Quit
End If

uri = WScript.Arguments(0)

' Strip the "openfolder://" prefix
Dim prefix
prefix = "openfolder://"
If LCase(Left(uri, Len(prefix))) = prefix Then
    encoded = Mid(uri, Len(prefix) + 1)
Else
    encoded = uri
End If

' Some browsers append a trailing slash to the whole URI - strip it
Do While Right(encoded, 1) = "/"
    encoded = Left(encoded, Len(encoded) - 1)
Loop

If Len(encoded) > 0 Then
    path = UTF8BytesToString(Base64ToBytes(Base64UrlToBase64(encoded)))
    If Len(path) > 0 Then
        If LCase(Left(path, 3)) <> "f:\" Then
            MsgBox "מטעמי אבטחה ניתן לפתוח רק תיקיות בכונן F:" & vbCrLf & path, vbExclamation, "פתיחת תיקייה"
            WScript.Quit
        End If
        On Error Resume Next
        CreateObject("Shell.Application").Explore path
        If Err.Number <> 0 Then
            MsgBox "לא ניתן לפתוח את התיקייה:" & vbCrLf & path, vbExclamation, "פתיחת תיקייה"
        End If
        On Error Goto 0
    End If
End If

Function Base64UrlToBase64(s)
    Dim result, padLen
    result = Replace(Replace(s, "-", "+"), "_", "/")
    padLen = (4 - (Len(result) Mod 4)) Mod 4
    Base64UrlToBase64 = result & String(padLen, "=")
End Function

Function Base64ToBytes(b64)
    Dim xmlDoc, node
    Set xmlDoc = CreateObject("MSXML2.DOMDocument")
    Set node = xmlDoc.createElement("b64")
    node.DataType = "bin.base64"
    node.Text = b64
    Base64ToBytes = node.nodeTypedValue
End Function

Function UTF8BytesToString(bytes)
    Dim stream
    Set stream = CreateObject("ADODB.Stream")
    stream.Type = 1 ' binary
    stream.Open
    stream.Write bytes
    stream.Position = 0
    stream.Type = 2 ' text
    stream.Charset = "utf-8"
    UTF8BytesToString = stream.ReadText
    stream.Close
End Function
