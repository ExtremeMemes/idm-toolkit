@echo off
 @echo off
 CLS
 ECHO.
 ECHO =============================
 ECHO Running Admin Invocation
 ECHO =============================

:init
 setlocal DisableDelayedExpansion
 set cmdInvoke=1
 set winSysFolder=System32
 set "batchPath=%~0"
 for %%k in (%0) do set batchName=%%~nk
 set "vbsGetPrivileges=%temp%\OEgetPriv_%batchName%.vbs"
 setlocal EnableDelayedExpansion

:checkPrivileges
  NET FILE 1>NUL 2>NUL
  if '%errorlevel%' == '0' ( goto gotPrivileges ) else ( goto getPrivileges )

:getPrivileges
  if '%1'=='ELEV' (echo ELEV & shift /1 & goto gotPrivileges)
  ECHO.
  ECHO **************************************
  ECHO Invoking UAC for Privilege Escalation
  ECHO **************************************

  ECHO Set UAC = CreateObject^("Shell.Application"^) > "%vbsGetPrivileges%"
  ECHO args = "ELEV " >> "%vbsGetPrivileges%"
  ECHO For Each strArg in WScript.Arguments >> "%vbsGetPrivileges%"
  ECHO args = args ^& strArg ^& " "  >> "%vbsGetPrivileges%"
  ECHO Next >> "%vbsGetPrivileges%"

  if '%cmdInvoke%'=='1' goto InvokeCmd 

  ECHO UAC.ShellExecute "!batchPath!", args, "", "runas", 1 >> "%vbsGetPrivileges%"
  goto ExecElevation

:InvokeCmd
  ECHO args = "/c """ + "!batchPath!" + """ " + args >> "%vbsGetPrivileges%"
  ECHO UAC.ShellExecute "%SystemRoot%\%winSysFolder%\cmd.exe", args, "", "runas", 1 >> "%vbsGetPrivileges%"

:ExecElevation
 "%SystemRoot%\%winSysFolder%\WScript.exe" "%vbsGetPrivileges%" %*
 exit /B

:gotPrivileges
 setlocal & cd /d %~dp0
 if '%1'=='ELEV' (del "%vbsGetPrivileges%" 1>nul 2>nul  &  shift /1)

 ::::::::::::::::::::::::::::
 ::BEGIN
 ::::::::::::::::::::::::::::




title IDM Toolkit
echo ===================================
echo IDM Toolkit v1.0
echo This Version Supports IDM 6.40b2
echo ===================================

:start
echo .
echo .
echo .
echo .
echo .
echo Choose an Option...
echo 1 - Activate + Patch Latest Version (Installed in C:\Program Files (x86)\Internet Download Manager)
echo 2 - Activate + Patch Latest Version (Installed in "C:\Program Files\Internet Download Manager")
echo 3 - Reset Trial + Remove Activation Info (Will not Remove Patch)
echo 4 - Just Activate, dont patch (Will get the error telling that the key is not genuine)
echo 5 - Install IDM
echo 6 - Exit


SET /p option=Choose one option - 
echo .
echo .
echo .

IF %option%==1 GOTO :patch

IF %option%==2 GOTO :patch32

IF %option%==3 GOTO :trial

IF %option%==4 GOTO :activate

IF %option%==5 GOTO :install

IF %option%==6 exit


:patch
echo Make sure IDM is closed (EVEN FROM TRAY)
pause
reg add "HKEY_CURRENT_USER\Software\DownloadManager" /v FName /t REG_SZ /d Internet
reg add "HKEY_CURRENT_USER\Software\DownloadManager" /v LName /t REG_SZ /d Download Manager
reg add "HKEY_CURRENT_USER\Software\DownloadManager" /v Email /t REG_SZ /d info@tonec.com
reg add "HKEY_CURRENT_USER\Software\DownloadManager" /v Serial /t REG_SZ /d 9QNBL-L2641-Y7WVE-QEN3I
echo .
echo .
cd rescources
xcopy IDMan.exe C:\Program Files (x86)\Internet Download Manager /i /q /y
cd..
goto :start

:patch32
echo Make sure IDM is closed (EVEN FROM TRAY)
pause
reg add "HKEY_CURRENT_USER\Software\DownloadManager" /v FName /t REG_SZ /d Internet
reg add "HKEY_CURRENT_USER\Software\DownloadManager" /v LName /t REG_SZ /d Download Manager
reg add "HKEY_CURRENT_USER\Software\DownloadManager" /v Email /t REG_SZ /d info@tonec.com
reg add "HKEY_CURRENT_USER\Software\DownloadManager" /v Serial /t REG_SZ /d 9QNBL-L2641-Y7WVE-QEN3I
echo .
echo .
cd rescources
xcopy IDMan.exe C:\Program Files\Internet Download Manager /i /q /y
cd..
goto :start

:trial
echo PLEASE PRESS YES ON THE POPUP OR ELSE THIS WILL NOT WORK
cd rescources
regedit idm-regreset.reg
cd..
pause
goto :start


:activate
echo Make sure IDM is closed (EVEN FROM TRAY)
pause
reg add "HKEY_CURRENT_USER\Software\DownloadManager" /v FName /t REG_SZ /d Internet
reg add "HKEY_CURRENT_USER\Software\DownloadManager" /v LName /t REG_SZ /d Download Manager
reg add "HKEY_CURRENT_USER\Software\DownloadManager" /v Email /t REG_SZ /d info@tonec.com
reg add "HKEY_CURRENT_USER\Software\DownloadManager" /v Serial /t REG_SZ /d 9QNBL-L2641-Y7WVE-QEN3I
goto :start

:install
cd rescources
idm-install.exe
ping 192.0.2.2 -n 1 -w 5000 > nul
:: PING IS FOR WAITING FOR 5 SECONDS
cd..
echo Press enter when you have finished the installation. . .
pause>nul
goto :start
