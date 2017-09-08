Option Explicit
On Error Resume Next

Dim objFileSys
Dim objFolder
Dim oFolder
Dim objFile
Dim svgName
Dim objShell
Dim Shell
Dim ans
Dim parent_dir


'�t�@�C���V�X�e���������I�u�W�F�N�g���쐬
Set objFileSys = CreateObject("Scripting.FileSystemObject")
Set Shell = WScript.CreateObject("WScript.Shell")
Set objShell = WScript.CreateObject("Shell.Application")

'msgbox objFileSys.getParentFolderName(WScript.ScriptFullName)
parent_dir = objFileSys.getParentFolderName(WScript.ScriptFullName)

If Err.Number = 0 Then
    Set objFolder = objShell.BrowseForFolder(0, "���݂̏ꏊ", 0, parent_dir)
    Shell.CurrentDirectory = objFolder.Items.Item.Path
'    Wscript.Echo Shell.CurrentDirectory
    Set oFolder = objFileSys.GetFolder(objFolder.Items.Item.Path)
    If Not objFolder Is Nothing Then
        WScript.Echo objFolder.Items.Item.Path
        For Each objFile In oFolder.Files
'            WScript.Echo objFile.Name
            If InStr(objFile.Name, ".svg") > 0 Then 
                '������̒���".svg"�̕���������΂����̏������s���܂��B
'                WScript.Echo objFile.Name
                svgName = replace(objFile.Name,".svg", ".wmf")
                Shell.Run """C:\Program Files\Inkscape\inkscape.exe"" --file " & objFile.Name & " --export-wmf " &svgName
           End If
       Next
        
    End If
Else
    WScript.Echo "�G���[�F" & Err.Description
End If

Set objFolder = Nothing
Set oFolder = Nothing
Set objFileSys = Nothing
Set objShell = Nothing
Set oShell = Nothing
