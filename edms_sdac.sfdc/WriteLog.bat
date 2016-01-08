@echo off

SETLOCAL
:: Set log file's path
set logpath=%~dp0%_log%.%logtype%
set csvpath=%~dp0%_log%.%logtype%\CSV
set logfile=! logs.txt

:: Don't write log if empty
if "%1"=="" goto:end

:: Create Log path
if not exist "%logpath%" (
	mkdir "%logpath%"
	REM echo y|cacls "%logpath%" /E /G Guest:R > nul
)

:: Create CSV done path
if not exist "%csvpath%" (
	mkdir "%csvpath%"
)
:: Write log header if log file not found
if not exist "%logpath%\%logfile%" (
	echo."Date"	"Time"	"Description" > "%logpath%\%logfile%"
)

:: Write log content
if exist "%logpath%\%logfiles%" (
	echo."%date%"	"%time: =0%"	"%*" >> "%logpath%\%logfile%"
) else (
	echo.Error writing log file!
	ping -n 3 -l 0 127.0.0.1 > nul
)

:: Exit
:end
ENDLOCAL
