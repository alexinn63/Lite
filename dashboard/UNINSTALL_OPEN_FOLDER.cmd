@echo off
setlocal

reg delete "HKCU\Software\Classes\openfolder" /f >nul 2>&1

if exist "%LOCALAPPDATA%\YachdavDashboard\OpenFolder.vbs" (
    del /Q "%LOCALAPPDATA%\YachdavDashboard\OpenFolder.vbs" >nul 2>&1
)

if exist "%LOCALAPPDATA%\YachdavDashboard" (
    rmdir "%LOCALAPPDATA%\YachdavDashboard" >nul 2>&1
)

echo.
echo פתיחת התיקיות הוסרה.
echo.
pause
