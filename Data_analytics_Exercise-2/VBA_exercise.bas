Attribute VB_Name = "Module1"
Sub stock():

Dim ticker As String
Dim ticker_next As String
Dim open_s As Double
Dim close_s As Double
Dim yearly_change As Double
Dim yearly_change_prcnt As Double
Dim total_vol As Variant
Dim vol As Long
Dim vol_next As Long
Dim lrow As Long
Dim lcol As Long
Dim output As Long

Dim starttime As Double
Dim runtime As Double

starttime = Timer

'Loops through each worksheet in the workbook
For Each ws In Worksheets

    ws.Select
    
    'sets output position to row 2 and calculated values to 0
    output = 2

    'calculates last row on the current sheet
    lrow = ws.Cells(Rows.Count, 1).End(xlUp).Row
    
    'calculates last column on the current sheet
    lcol = ws.Cells(1, Columns.Count).End(xlToLeft).Column

    'sorts sheet by ticker name and then date
    With ws.Sort
     .SortFields.Add Key:=Range("A1"), Order:=xlAscending
     .SortFields.Add Key:=Range("B1"), Order:=xlAscending
     .SetRange Range(Cells(1, 1), Cells(lrow, lcol))
     .Header = xlYes
     .Apply
    End With
    
    'Labels headers for output table 1
    Cells(1, 9).Value = "Ticker"
    Cells(1, 10).Value = "Yearly Change"
    Cells(1, 11).Value = "Percentage change"
    Cells(1, 12).Value = "Total Volume"
    
    'Labels headers for output table 2
    Cells(1, 16).Value = "Ticker"
    Cells(1, 17).Value = "Value"
    Cells(2, 15).Value = "Greatest % Increase"
    Cells(3, 15).Value = "Greatest % Decrease"
    Cells(4, 15).Value = "Greatest Total Volume"

    'formats the table with desired properties and significant digits
    Columns("J").NumberFormat = "0.000"
    Columns("K").NumberFormat = "0.000%"
    Columns("L").NumberFormat = "0"
    Cells(4, 17).NumberFormat = "0"
    Range(Cells(2, 17), Cells(3, 17)).NumberFormat = "0.000%"
        
    'Loops through each row identifying the current (i) ticker
    'as well as the proceeding (i+1) ticker
    For i = 2 To lrow
    
        'assigns ticker values and corresponding volume
        ticker = Cells(i, 1).Value
        ticker_next = Cells(i + 1, 1).Value
        vol_next = Cells(i + 1, 7).Value
        
        'contingency to catch any tickers where their opening value changes from 0 to positive integer
        ' at some arbitrary point in the year
        If open_s = 0 And Cells(i + 1, 3).Value > 0 And ticker = ticker_next Then
            open_s = Cells(i + 1, 3).Value
        End If
        
        'prints ticker ID to output table
        If Cells(output, 9).Value = "" Then
            Cells(output, 9).Value = ticker
        End If
        
        'condition to account for the first row
        If i = 2 Then
            total_vol = Cells(i, 7).Value + vol_next
            open_s = Cells(i, 3).Value
        'condition which compares the current ticker with the
        'proceeding ticker, and initiates total volume calculation
        ElseIf ticker = ticker_next Then
            total_vol = total_vol + vol_next
            
        ElseIf ticker <> ticker_next Then
            'captures the closing value at the end of the ticker range
            close_s = Cells(i, 6).Value
            
            If open_s > 0 Then
                yearly_change = close_s - open_s
                yearly_change_prcnt = yearly_change / open_s
            Else
                'contingency for when open and close is = 0
                Range(Cells(output, 10), Cells(output, 12)).Value = "N/A"
                'prepares for the next row
                total_vol = vol_next
                open_s = Cells(i + 1, 3).Value
                output = output + 1
                'exits to the next row immediately
                GoTo dropoff
            End If
            
            'prints yearly change to output table 1
            Cells(output, 10).Value = yearly_change
            
            ' code to change color of yearly_change cell based on >0 or <0
            If yearly_change > 0 Then
                Cells(output, 10).Interior.Color = vbGreen
            ElseIf yearly_change <= 0 Then
                Cells(output, 10).Interior.Color = vbRed
            End If
            
            'prints total volume,and % change to output table
            Cells(output, 11).Value = yearly_change_prcnt
            Cells(output, 12).Value = total_vol
            
            ' block to control when output table 1 is only one line;populates output table 2 with first
            ' entries from output 1
            If output = 2 Then
                Range(Cells(2, 16), Cells(3, 16)).Value = ticker
                Range(Cells(2, 17), Cells(3, 17)).Value = yearly_change_prcnt
                
            ' for each line, checks if the current yearly_change_prcnt is greater
            ' than the previous array of values, if so, update output 2 table
            ElseIf yearly_change_prcnt > Cells(2, 17).Value Then
                Cells(2, 16).Value = ticker
                Cells(2, 17).Value = yearly_change_prcnt
                
            ' for each line, checks if the current yearly_change_prcnt is less
            ' than the previous array of values, if so, update output 2 table
            ElseIf yearly_change_prcnt < Cells(3, 17).Value Then
                Cells(3, 16).Value = ticker
                Cells(3, 17).Value = yearly_change_prcnt
            End If
            
            'code block that does the same thing as above for total_vol
            If output = 2 Then
                Cells(4, 16).Value = ticker
                Cells(4, 17).Value = total_vol
            ElseIf total_vol > Cells(4, 17).Value Then
                Cells(4, 16).Value = ticker
                Cells(4, 17).Value = total_vol
            End If
            
            're-assigns values for the next unique ticker
            total_vol = vol_next
            
             open_s = Cells(i + 1, 3).Value
            
            'increases the increment to start a new line in the output table
            output = output + 1
        End If
dropoff:
    Next i

Next ws

runtime = Timer - starttime
MsgBox ("runtime: " + Str(runtime))

End Sub


