Option Explicit

' VBScript���Ǘ��Ҍ����Ŏ��s����
' https://www.server-world.info/query?os=Other&p=vbs&f=1
Dim WMI, OS, Value, Shell
do while WScript.Arguments.Count = 0 and WScript.Version >= 5.7
    '##### WScript5.7 �܂��� Vista �ȏォ���`�F�b�N
    Set WMI = GetObject("winmgmts:" & "{impersonationLevel=impersonate}!\\.\root\cimv2")
    Set OS = WMI.ExecQuery("SELECT *FROM Win32_OperatingSystem")
    For Each Value in OS
    if left(Value.Version, 3) < 6.0 then exit do
    Next

    '##### �Ǘ��Ҍ����Ŏ��s
    Set Shell = CreateObject("Shell.Application")
    Shell.ShellExecute "wscript.exe", """" & WScript.ScriptFullName & """ uac", "", "runas"

    WScript.Quit
loop

'##### ���C�����������s

Dim oWshShell
Dim szArch
Set oWshShell = CreateObject("WScript.Shell")
szArch = oWshShell.Environment("Process").Item("PROCESSOR_ARCHITECTURE")

WScript.Echo "�C���X�g�[�����n�߂܂��B(" & szArch & ")"

Dim result, CancelFlag, return
Dim objShell, cmd, DirName

' �C���X�g�[�����邩�A���Ȃ����A�ȍ~�L�����Z�����邩�B
Function InstallSoft(comment, objShell, cmd, CancelFlag)
	If CancelFlag = "DoIt" Then
		InstallSoft = "DoIt"
		result = MsgBox(comment, vbYesNoCancel, "�\�t�g�̃C���X�g�[��")
		If result = vbYes Then
			'WScript.Echo "vbYes"
			'objShell.Run cmd
			' https://msdn.microsoft.com/ja-jp/library/cc364421.aspx
			return = objShell.Run(cmd, 1, True)
		Else
			If result = vbCancel Then
				'WScript.Echo "vbCancel"
				InstallSoft = "Cancel"
			End If
		End If
	End If
End Function

DirName = Replace(WScript.ScriptFullName,WScript.ScriptName,"")

CancelFlag = "DoIt"
'CancelFlag = InstallSoft("qqqq", "qqqq", CancelFlag)
'WScript.echo CancelFlag

Set objShell = CreateObject("WScript.Shell")
' objShell.Run "cmd /c ipconfig /all > c:\ip.txt",0,false

' sakura_install2-2-0-1.exe
CancelFlag = InstallSoft("�T�N���G�f�B�^�[" & "���C���X�g�[�����܂��B", objShell, DirName & "software\sakura_install2-2-0-1.exe", CancelFlag)


' mecab-0.996.exe
CancelFlag = InstallSoft("mecab-0.996.exe" & "���C���X�g�[�����܂��B" & vbCr & "�����R�[�h��UTF8��I��ł��������B", objShell, DirName & "software\mecab-0.996.exe", CancelFlag)

' x86
Dim swipl_exe
swipl_exe = "swipl-w32-740-rc2.exe"

' swipl-w32-740-rc2.exe
CancelFlag = InstallSoft(swipl_exe & "���C���X�g�[�����܂��B", objShell, DirName & "software\" & swipl_exe, CancelFlag)

' R-3.3.2-win.exe
CancelFlag = InstallSoft("R-3.3.2-win.exe" & "���C���X�g�[�����܂��B" & vbCr & "64bit�̃`�F�b�N���O���Ă��܂��܂���B", objShell, DirName & "software\R-3.3.2-win.exe", CancelFlag)

' graphviz-2.38.msi
CancelFlag = InstallSoft("graphviz-2.38.msi" & "���C���X�g�[�����܂��B", objShell, DirName & "software\graphviz-2.38.msi", CancelFlag)


'===============================================================================
' Jupyter��PumpkinPyParser���\�[�X�œ�����

' Python 3.x �p�̊��̍쐬(�s�v)
' pycharm-community-2016.3.2.exe
'��œ���Ȃ��Ƃ��߂����B
'cmd = Replace(WScript.ScriptFullName,WScript.ScriptName,"") & "batch\py2py3.bat"
'WScript.echo cmd
'objShell.Run  cmd

' PumpkinPyParser SetUp_x.xx.exe

Dim ppp_version
ppp_version = "0.997"
CancelFlag = InstallSoft("PumpkinPyParser SetUp_" & ppp_version & ".exe" & "���C���X�g�[�����܂��B", objShell, """" & DirName & "software\PumpkinPyParser SetUp_" & ppp_version & ".exe""", CancelFlag)


'===============================================================================

