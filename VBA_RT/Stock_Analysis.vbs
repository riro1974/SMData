Attribute VB_Name = "Module1"
Sub Stock_Analysis()
  '--------------------------------------------------------------------------------
  ' BEGIN - Variable Declaration
  '--------------------------------------------------------------------------------
  Dim Ticker_Name As String
  Dim Stock_Total As Double
  Dim n As Integer
  Dim Open_Stock As Double
  Dim Close_Stock As Double
  Dim Yearly_Change As Double
  Dim Percent_Change As Double
  Dim i As Long
  Dim j As Long
  Dim minpercentvalue As Double
  Dim maxpercentvalue As Double
  Dim maxtotalvalue As Double
  Dim maxrownum As Double
  Dim minrownum As Double
  Dim maxtickr As String
  Dim volrownum As Double
  Dim voltickr As String
  Dim WS As Worksheet
  '--------------------------------------------------------------------------------
  ' END - Variable Declaration
  '--------------------------------------------------------------------------------
  
  '--------------------------------------------------------------------------------
  ' BEGIN - Analysis of each worksheet in the workbook
  '--------------------------------------------------------------------------------
  For Each WS In ThisWorkbook.Worksheets
  Stock_Total = 0
  Dim Summary_Table_Row As Integer
  Summary_Table_Row = 2
  With WS
        .Columns(8).ClearContents
        .Columns(9).ClearContents
        .Columns(10).ClearContents
        .Columns(12).ClearContents
        .Columns(13).ClearContents
        .Columns(14).ClearContents
        .Range("H1").Value = "Ticker"
        .Range("I1").Value = "Yearly Change"
        .Range("J1").Value = "Percent Change"
        .Range("K1").Value = "Total Stock Volume"
        .Range("O1").Value = "Ticker"
        .Range("P1").Value = "Value"
        .Range("N2:N4") = Application.Transpose(Array("Greatest % Increase", "Greatest % Decrease", "Greatest Total Volume"))
  End With
  WS.Activate
    lastrow = WS.Cells(Rows.Count, 1).End(xlUp).Row
    j = 2
    For i = 2 To lastrow
      Open_Stock = WS.Cells(j, 3).Value
      If WS.Cells(i + 1, 1).Value <> WS.Cells(i, 1).Value Then
          Ticker_Name = WS.Cells(i, 1).Value
          Stock_Total = Stock_Total + WS.Cells(i, 7).Value
          WS.Range("H" & Summary_Table_Row).Value = Ticker_Name
          WS.Range("K" & Summary_Table_Row).Value = Stock_Total
          ' Close_Stock = WS.Cells(i, 6).Value
          WS.Range("I" & Summary_Table_Row).Value = WS.Cells(i, 6).Value - Open_Stock
          Yearly_Change = WS.Range("I" & Summary_Table_Row).Value
          If Yearly_Change < 0 Then
              WS.Range("I" & Summary_Table_Row).Interior.ColorIndex = 3
          Else: WS.Range("I" & Summary_Table_Row).Interior.ColorIndex = 4
          End If
          If Open_Stock = 0 Then
            Percent_Change = 0
          Else: Percent_Change = Yearly_Change / Open_Stock
          End If
          WS.Range("J" & Summary_Table_Row).Value = Percent_Change
          Summary_Table_Row = Summary_Table_Row + 1
          Stock_Total = 0
          j = i + 1
      Else
          Stock_Total = Stock_Total + WS.Cells(i, 7).Value
      End If
    Next i
    
    llastrow = Range("J" & Rows.Count).End(xlUp).Row
    maxpercentvalue = WorksheetFunction.Max((WS.Range("J" & 2 & ":J" & llastrow)))
    WS.Range("P2").Value = maxpercentvalue
    minpercentvalue = WorksheetFunction.Min((WS.Range("J" & 2 & ":J" & llastrow)))
    WS.Range("P3").Value = minpercentvalue
    maxtotalvalue = WorksheetFunction.Max((WS.Range("K" & 2 & ":K" & llastrow)))
    WS.Range("P4").Value = maxtotalvalue
    maxrownum = Application.Match(maxpercentvalue, WS.Range("J" & 2 & ":J" & llastrow), 0)
    maxtickr = Application.WorksheetFunction.Index(WS.Range("H" & 2 & ":H" & llastrow), maxrownum, 0)
    minrownum = Application.Match(minpercentvalue, WS.Range("J" & 2 & ":J" & llastrow), 0)
    mintickr = Application.WorksheetFunction.Index(WS.Range("H" & 2 & ":H" & llastrow), minrownum, 0)
    volrownum = Application.Match(maxtotalvalue, WS.Range("K" & 2 & ":K" & llastrow), 0)
    voltickr = Application.WorksheetFunction.Index(WS.Range("H" & 2 & ":H" & llastrow), volrownum, 0)
    WS.Range("O2").Value = maxtickr
    WS.Range("O3").Value = mintickr
    WS.Range("O4").Value = voltickr
    WS.Range("P2:P3").NumberFormat = "0.00%"
    WS.Range("J" & 2 & ":J" & llastrow).NumberFormat = "0.00%"
    WS.Range("P4").NumberFormat = "0"
    WS.Range("A1").CurrentRegion.WrapText = True
    '--------------------------------------------------------------------------------
    ' BEGIN - Analysis of each worksheet in the workbook
    '--------------------------------------------------------------------------------
  Next WS
End Sub
