@echo off
setlocal

REM Usage: mod-deployment-script.bat <input> <output> <target>
REM input  - folder or file to zip
REM output - name of the zip file (with .zip extension)
REM target - directory to copy the zip file to

set "input=%~1"
set "output=%~2"
set "target=%~3"

REM Remove output zip if it already exists in current directory
if exist "%output%" del /f /q "%output%"

REM Create zip archive of input (requires PowerShell 5+)
powershell -Command "Compress-Archive -Path '%input%' -DestinationPath '%output%' -Force"

REM Copy zip to target directory, overwrite if exists
copy /Y "%output%" "%target%\%output%"

echo Deployment complete: %output% copied to %target%
endlocal