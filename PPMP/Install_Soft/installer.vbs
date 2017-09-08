Option Explicit

' VBScriptを管理者権限で実行する
' https://www.server-world.info/query?os=Other&p=vbs&f=1
Dim WMI, OS, Value, Shell
do while WScript.Arguments.Count = 0 and WScript.Version >= 5.7
    '##### WScript5.7 または Vista 以上かをチェック
    Set WMI = GetObject("winmgmts:" & "{impersonationLevel=impersonate}!\\.\root\cimv2")
    Set OS = WMI.ExecQuery("SELECT *FROM Win32_OperatingSystem")
    For Each Value in OS
    if left(Value.Version, 3) < 6.0 then exit do
    Next

    '##### 管理者権限で実行
    Set Shell = CreateObject("Shell.Application")
    Shell.ShellExecute "wscript.exe", """" & WScript.ScriptFullName & """ uac", "", "runas"

    WScript.Quit
loop

'##### メイン処理を実行

Dim oWshShell
Dim szArch
Set oWshShell = CreateObject("WScript.Shell")
szArch = oWshShell.Environment("Process").Item("PROCESSOR_ARCHITECTURE")

WScript.Echo "インストールを始めます。(" & szArch & ")"

Dim result, CancelFlag, return
Dim objShell, cmd, DirName

' インストールするか、しないか、以降キャンセルするか。
Function InstallSoft(comment, objShell, cmd, CancelFlag)
	If CancelFlag = "DoIt" Then
		InstallSoft = "DoIt"
		result = MsgBox(comment, vbYesNoCancel, "ソフトのインストール")
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
CancelFlag = InstallSoft("サクラエディター" & "をインストールします。", objShell, DirName & "software\sakura_install2-2-0-1.exe", CancelFlag)


' mecab-0.996.exe
CancelFlag = InstallSoft("mecab-0.996.exe" & "をインストールします。" & vbCr & "文字コードはUTF8を選んでください。", objShell, DirName & "software\mecab-0.996.exe", CancelFlag)

' x86
Dim swipl_exe
swipl_exe = "swipl-w32-740-rc2.exe"

' swipl-w32-740-rc2.exe
CancelFlag = InstallSoft(swipl_exe & "をインストールします。", objShell, DirName & "software\" & swipl_exe, CancelFlag)

' R-3.3.2-win.exe
CancelFlag = InstallSoft("R-3.3.2-win.exe" & "をインストールします。" & vbCr & "64bitのチェックを外してかまいません。", objShell, DirName & "software\R-3.3.2-win.exe", CancelFlag)

' graphviz-2.38.msi
CancelFlag = InstallSoft("graphviz-2.38.msi" & "をインストールします。", objShell, DirName & "software\graphviz-2.38.msi", CancelFlag)


'===============================================================================
' JupyterとPumpkinPyParserをソースで動かす

' Python 3.x 用の環境の作成(不要)
' pycharm-community-2016.3.2.exe
'手で入れないとだめかも。
'cmd = Replace(WScript.ScriptFullName,WScript.ScriptName,"") & "batch\py2py3.bat"
'WScript.echo cmd
'objShell.Run  cmd

' PumpkinPyParser SetUp_x.xx.exe

Dim ppp_version
ppp_version = "0.997"
CancelFlag = InstallSoft("PumpkinPyParser SetUp_" & ppp_version & ".exe" & "をインストールします。", objShell, """" & DirName & "software\PumpkinPyParser SetUp_" & ppp_version & ".exe""", CancelFlag)


'===============================================================================

