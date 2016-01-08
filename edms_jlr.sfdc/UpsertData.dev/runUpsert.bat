@echo off
echo.
if "%label%"=="" (
	echo Label not define. Please do NOT execute this on its own.
	goto:eof
)
if "%svcname%"=="" (
	echo Service name not defined. Please do NOT execute this on its own.
	goto:eof
)
if "%srcfile%"=="" (
	echo Source file not defined. Please do NOT execute this on its own.
	goto:eof
)

title Running Job -- %label%

pushd ..\LoaderObj
call ..\WriteLog.bat Begin uploading %label% data . . .

if not exist "%source%" (
	call ..\WriteLog.bat Source file not found "%source%". Data load skipped!
	goto:eof
)

call process.bat "%srcpath%" %svcname% > %logfile%

:: Move uploaded CSV to \CSV\Done\
call ..\WriteLog.bat Moving source %label% data into "%target%" . . .
move "%source%" "%target%" >nul

:: Move log files to \Logs\
call ..\WriteLog.bat Moving process log file into "%log%" . . .
move %logfile% "%log%" >nul
call ..\WriteLog.bat Moving upsert %label% success log into "%logok%" . . .
move %csv_ok% "%logok%" >nul
call ..\WriteLog.bat Moving upsert %label% error log into "%loger%" . . .
move %csv_error% "%loger%" >nul

popd

:eof
