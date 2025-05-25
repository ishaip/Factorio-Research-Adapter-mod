@echo off
setlocal

REM Usage: mod-deployment-script.bat <input> <output> <target>
REM input  - folder or file to zip
REM output - name of the zip file (with or without .zip extension)
REM target - directory to copy the zip file to

set input=Space-Age-Research-Adapter
set output=Space-Age-Research-Adapter_1.0.0
set target=%appdata%\Factorio\mods

REM Ensure output ends with .zip
set zipname=%output%
if /I not "%zipname:~-4%"==".zip" set zipname=%zipname%.zip

REM Remove output zip if it already exists in current directory
if exist "%zipname%" del /f /q "%zipname%"

REM Create zip archive of input (requires PowerShell 5+)
powershell -Command "Compress-Archive -Path '%input%' -DestinationPath '%zipname%' -Force"

REM Copy zip to target directory, overwrite if exists
copy /Y "%zipname%" "%target%\%zipname%"

echo Deployment complete: %zipname% copied to %target%
pause
endlocal