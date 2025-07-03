@echo off
:: Silent One-Click Task Killer - No warnings, immediate action
:: Must be run as Administrator for full effectiveness

:: Check for admin rights silently
NET SESSION >nul 2>&1
if %errorLevel% neq 0 (
    start "" /min cmd /c "echo Task Killer requires Admin rights && pause"
    exit /b
)

:: Kill all user processes immediately
taskkill /f /fi "USERNAME eq %USERNAME%" >nul 2>&1

:: Force kill remaining processes except system critical
for /f "tokens=1,2" %%a in ('tasklist /v /fo csv /nh') do (
    set "process=%%~a"
    set "process=!process:"=!"
    set "pid=%%~b"
    set "pid=!pid:"=!"
    
    :: Skip protected system processes
    echo !process!|findstr /i /c:"svchost.exe" >nul && goto :next
    echo !process!|findstr /i /c:"dwm.exe" >nul && goto :next
    echo !process!|findstr /i /c:"explorer.exe" >nul && goto :next
    echo !process!|findstr /i /c:"winlogon.exe" >nul && goto :next
    
    :: Kill everything else
    taskkill /f /pid !pid! >nul 2>&1
    
    :next
)

:: Refresh desktop silently
taskkill /f /im explorer.exe >nul 2>&1
start explorer.exe >nul

exit