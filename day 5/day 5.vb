Imports System
Imports System.Text.RegularExpressions
Module Program
    Sub Main(args As String())
        Dim veins As String()
        Dim parseRegex = New Regex("(\d*),(\d*) -> (\d*),(\d*)")
        veins = System.IO.File.ReadAllLines("day 5.txt")
        Dim mapMultiple = New HashSet(Of (Integer, Integer))
        Dim maxPos = 0
        For Each vein As String In veins
            Dim x As Integer
            Dim groups = parseRegex.Match(vein).Groups
            x = groups(1).Value
            maxPos = Math.Max(maxPos, x)
            x = groups(2).Value
            maxPos = Math.Max(maxPos, x)
            x = groups(3).Value
            maxPos = Math.Max(maxPos, x)
            x = groups(4).Value
            maxPos = Math.Max(maxPos, x)
        Next
        Dim mapSingle(maxPos, maxPos) As Boolean
        For Each vein As String In veins
            Dim x1, y1, x2, y2 As Integer
            Dim groups = parseRegex.Match(vein).Groups
            x1 = groups(1).Value
            y1 = groups(2).Value
            x2 = groups(3).Value
            y2 = groups(4).Value

            If x1 = x2 Then
                For i = Math.Min(y1, y2) To Math.Max(y1, y2)
                    If mapSingle(x1, i) = 0 Then
                        mapSingle(x1, i) = 1
                    Else
                        mapMultiple.Add((x1, i))
                    End If
                Next
            End If

            If y1 = y2 Then
                For i = Math.Min(x1, x2) To Math.Max(x1, x2)
                    If mapSingle(i, y1) = 0 Then
                        mapSingle(i, y1) = 1
                    Else
                        mapMultiple.Add((i, y1))
                    End If
                Next
            End If
        Next
        Console.WriteLine(mapMultiple.Count)
        For Each vein As String In veins
            Dim x1, y1, x2, y2 As Integer
            Dim groups = parseRegex.Match(vein).Groups
            x1 = groups(1).Value
            y1 = groups(2).Value
            x2 = groups(3).Value
            y2 = groups(4).Value

            If Not x1 = x2 AndAlso Not y1 = y2 Then
                Dim signY = Math.Sign(y1 - y2)
                Dim signX = Math.Sign(x1 - x2)
                For i = 0 To Math.Abs(y1 - y2)
                    If mapSingle(x1 - i * signX, y1 - i * signY) = 0 Then
                        mapSingle(x1 - i * signX, y1 - i * signY) = 1
                    Else
                        mapMultiple.Add((x1 - i * signX, y1 - i * signY))
                    End If
                Next
            End If
        Next
        Console.WriteLine(mapMultiple.Count)
    End Sub
End Module
