@echo off
setlocal

set "APPDIR=%LOCALAPPDATA%\YachdavDashboard"
set "LAUNCHER=%APPDIR%\OpenFolder.vbs"

if not exist "%APPDIR%" mkdir "%APPDIR%"
if errorlevel 1 goto :error

copy /Y "%~dp0OpenFolder.vbs" "%LAUNCHER%" >nul
if errorlevel 1 goto :error

reg add "HKCU\Software\Classes\openfolder" /ve /d "URL:OpenFolder Protocol" /f >nul
if errorlevel 1 goto :error

reg add "HKCU\Software\Classes\openfolder" /v "URL Protocol" /d "" /f >nul
if errorlevel 1 goto :error

reg add "HKCU\Software\Classes\openfolder\shell\open\command" /ve /d "wscript.exe \"%LAUNCHER%\" \"%%1\"" /f >nul
if errorlevel 1 goto :error

echo.
echo ההתקנה הושלמה בהצלחה.
echo אפשר לסגור את החלון ולפתוח את dashboard.html.
echo.
pause
exit /b 0

:error
echo.
echo ההתקנה נכשלה. פנו למי שמתחזק את המחשב.
echo.
pause
exit /b 1
