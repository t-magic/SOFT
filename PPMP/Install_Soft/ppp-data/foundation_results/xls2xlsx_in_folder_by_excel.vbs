Option Explicit

'Dim WScript.Arguments
Dim full_xls_fname
Dim full_xlsx_fname
'full_xls_fname = WScript.Arguments.Item(0)

Dim objFileSys
Dim objFolder
Dim objFile
Dim lngPos
Dim array
Dim xlsx_file
Dim xlApp
Dim xlWorkbook
Dim parent_dir
Dim oFolder
Dim Shell
Dim objShell

Set xlApp = CreateObject("Excel.Application")
xlApp.DisplayAlerts = False

'ファイルシステムを扱うオブジェクトを作成
Set objFileSys = CreateObject("Scripting.FileSystemObject")
Set Shell = WScript.CreateObject("WScript.Shell")
Set objShell = WScript.CreateObject("Shell.Application")

msgbox objFileSys.getParentFolderName(WScript.ScriptFullName)
parent_dir = objFileSys.getParentFolderName(WScript.ScriptFullName)

If Err.Number = 0 Then

    Set objFolder = objShell.BrowseForFolder(0, "現在の場所", 0, parent_dir)
    Shell.CurrentDirectory = objFolder.Items.Item.Path
'    Wscript.Echo Shell.CurrentDirectory
    Set oFolder = objFileSys.GetFolder(objFolder.Items.Item.Path)

    If Not objFolder Is Nothing Then
        'WScript.Echo objFolder.Items.Item.Path
        
        For Each objFile In oFolder.Files
            'WScript.Echo objFile.Name
            full_xls_fname = oFolder & "\" & objFile.Name
            'WScript.Echo "full_xls_fname = " & full_xls_fname
            array = Split(full_xls_fname, ".")
            If array(UBound(array)) = "xls" Then
                '取得したファイルのファイル名を表示
                'WScript.Echo full_xls_fname
                array(UBound(array)) = "xlsx"
                full_xlsx_fname = Join(array, ".")
                Set xlWorkbook = xlApp.Workbooks.Open(full_xls_fname)
                xlWorkbook.SaveAs full_xlsx_fname, 51
                xlWorkbook.Close
            End If
        Next
    End If
Else
    WScript.Echo "エラー：" & Err.Description
End If

Set objFolder = Nothing
Set objFileSys = Nothing 


