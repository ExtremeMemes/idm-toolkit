@echo off
 ::::::::::::::::::::::::::::
 ::ADMIN PERMS REQUESTING
 ::::::::::::::::::::::::::::
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
 ::SCRIPT BEGIN
 ::::::::::::::::::::::::::::

set support=Current supported versions are 6.40 and 6.41. Do not update after you have patched the Software.
:: %support%

title github.com/ExtremeMemes/idm-toolkit, version 2.0
echo ===================================
echo IDM Toolkit v1.0
echo This Version Supports IDM 6.40 to 6.41
echo ===================================

mkdir rescources
:: Makes Directory
:start
echo .
echo .
echo .
echo .
echo .
echo .
echo .

echo Choose an Option...
echo Currently Supported Versions: 6.40 and  6.41
echo 1 - Activate + Patch Latest Version (Installed in C:\Program Files (x86)\Internet Download Manager)
echo 2 - Activate + Patch Latest Version (Installed in "C:\Program Files\Internet Download Manager")
echo 3 - Reset Trial + Remove Activation Info (Will not Remove Patch, Reinstall to remove patch)
echo 4 - Just Activate, dont patch (Will get the error telling that the key is not genuine)
echo 5 - Install IDM
echo 6 - Terminate IDM Tasks
echo 7 - Exit


SET /p option=Choose one option - 
echo .
echo .
echo .
echo .
echo .
echo You chose option %option%
IF %option%==1 GOTO :patch

IF %option%==2 GOTO :patch32

IF %option%==3 GOTO :trial

IF %option%==4 GOTO :activate

IF %option%==5 GOTO :install

IF %option%==6 GOTO :kill

IF %option%==7 GOTO :exit

:: currently not needed, saving for later, first set for local user, and other is for all users
:: reg add "HKEY_CURRENT_USER\Software\DownloadManager" /v FName /t REG_SZ /d Internet
:: reg add "HKEY_CURRENT_USER\Software\DownloadManager" /v LName /t REG_SZ /d Download Manager
:: reg add "HKEY_CURRENT_USER\Software\DownloadManager" /v Email /t REG_SZ /d info@tonec.com
:: reg add "HKEY_CURRENT_USER\Software\DownloadManager" /v Serial /t REG_SZ /d 9QNBL-L2641-Y7WVE-QEN3I

:: reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Internet Download Manager" /v FName /t REG_SZ /d Internet
:: reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Internet Download Manager" /v LName /t REG_SZ /d Download Manager
:: reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Internet Download Manager" /v Email /t REG_SZ /d info@tonec.com
:: reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Internet Download Manager" /v Serial /t REG_SZ /d 9QNBL-L2641-Y7WVE-QEN3I



:patch
echo Make sure IDM is closed (EVEN FROM TRAY)
echo Please also press "Yes" on the popup!
pause
echo .
echo .
echo %support%
SET /p pver=Choose a Version - 
cd rescources
:: Add curl, example is curl --silent --output https://insert-url.here/file.exe
curl --silent --output IDMan.exe https://raw.githubusercontent.com/ExtremeMemes/idm-toolkit/main/res/%pver%/IDMan.exe
curl --silent --output patchkey.reg https://raw.githubusercontent.com/ExtremeMemes/idm-toolkit/main/res/patchkey.reg
ren "C:\Program Files (x86)\Internet Download Manager\IDMan.exe" "IDMan.exe.bak"
echo If you want to remove the patch, delete IDMan.exe and rename IDMan.exe.bak to IDMan.exe
xcopy IDMan.exe "C:\Program Files (x86)\Internet Download Manager" /i /q /y
regedit patchkey.reg
pause
del /q IDMan.exe
del /q patchkey.reg
cd..
goto :start


:patch32
echo Make sure IDM is closed (EVEN FROM TRAY)
echo Please also press "Yes" on the popup!
pause
echo .
echo .
echo %support%
SET /p pver32=Choose a Version - 
cd rescources
curl --silent --output IDMan.exe https://raw.githubusercontent.com/ExtremeMemes/idm-toolkit/main/res/%pver32%/IDMan.exe
curl --silent --output patchkey.reg https://raw.githubusercontent.com/ExtremeMemes/idm-toolkit/main/res/patchkey.reg
ren "C:\Program Files\Internet Download Manager\IDMan.exe" "IDMan.exe.bak"
echo If you want to remove the patch, delete IDMan.exe and rename IDMan.exe.bak to IDMan.exe
xcopy IDMan.exe "C:\Program Files\Internet Download Manager" /i /q /y
regedit patchkey.reg
pause
del /q IDMan.exe
del /q patchkey.reg
cd..
goto :start

:trial
echo Make sure IDM is closed (EVEN FROM TRAY)
echo Please also press "Yes" on the popup!
pause
cd rescources
curl --silent --output idm-regreset.reg https://raw.githubusercontent.com/ExtremeMemes/idm-toolkit/main/res/idm-regreset.reg
regedit idm-regreset.reg
pause > nul
del /q idm-regreset.reg
cd..
goto :start


:activate
echo Make sure IDM is closed (EVEN FROM TRAY)
echo Please also press "Yes" on the popup!
pause
cd rescources
curl --silent --output only-activate.reg https://raw.githubusercontent.com/ExtremeMemes/idm-toolkit/main/res/only-activate.reg
regedit only-activate.reg
del /q only-activate.reg
cd..
goto :start


:install
echo .
echo .
echo .
echo %support%
SET /p version=Choose a Version - 
cd rescources
curl --silent --output idm-install.exe https://raw.githubusercontent.com/ExtremeMemes/idm-toolkit/main/res/%version%/idm-install.exe
idm-install.exe
ping 192.0.2.2 -n 1 -w 5000 > nul
:: PING IS FOR WAITING FOR 5 SECONDS
echo Press enter when you have finished the installation. . .
pause > nul
del /q idm-install.exe
cd..
goto :start

:kill
echo Press enter to kill the IDM task...
pause > nul
TASKKILL /F /IM IDMan.exe
TASKKILL /F /IM IEMonitor.exe
goto :start
:exit
rmdir /s rescources
exit
